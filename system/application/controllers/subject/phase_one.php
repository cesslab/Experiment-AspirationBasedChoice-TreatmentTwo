<?php
    class phase_one extends MY_Controller{

        public function __construct() {
            parent::__construct();

            $this->subj_session_data = $this->_get_subject_session_data();

            $this->subj = new Subject(
                    $this->subj_session_data['id'],
                    $this->subj_session_data['login'],
                    $this->subj_session_data['auth'],
                    $this->subj_session_data['experiment_id']);

            // valid authentication required
            if(!$this->subj->authenticate()){
                $this->session->sess_destroy();
                redirect('subject/login');
            }

            $this->exp = new Experiment($this->subj_session_data['experiment_id']);

            $this->_redirect_if_required();

            // set the current round index
            if($this->subj->current_round == 0){
                $index = 0;
                $this->_set_first_round($index);
                $this->subj->set_current_round_index($index); // set to fist element in the array
            }
            elseif($this->subj->current_round != 0){
                $rounds = $this->subj->first_stage_order;
                $current_round_index = array_search($this->subj->current_round, $rounds);
                $this->subj->set_current_round_index($current_round_index);
            }
            
            $this->output->set_header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
           	$this->output->set_header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0"); 
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0"); 
			$this->output->set_header("Pragma: no-cache");  
        }

        public function index(){
            // get form data & set form validation
            $this->data = $this->_get_form_data();
            $this->_set_form_validation();
            
            $form_entries_valid = false;
            if($this->input->server('REQUEST_METHOD') === 'POST'){
            	$form_entries_valid = $this->form_validation->run();
            }
            
            if(!$form_entries_valid){
                 $this->load->view('subject/phase_one', $this->data);
                 return;
            }

            // selected bundle insertion fails
            if(!$this->_add_selected_bundle()){
                $this->load->view('subject/phase_one', $this->data);
                 return;
            }

            // increment index, round and move on
            $this->_move_to_next_round();
        }

        /**
         * Moves the subject to the next round or to a holding screen
         */
        private function _move_to_next_round(){
            $current_round_index = $this->subj->get_current_round_index();
            $next_round_index = $current_round_index + 1;

            $rounds = $this->subj->first_stage_order;
            
        	$round = $this->exp->get_phase_one_round_by_id($this->subj->current_round);
        	if($round['round_type'] == 'parent' || $round['round_type'] == 'single'){
            	$phase= 1;
            	$this->exp->insert_displayed_round_id($this->subj->round_counter, $this->subj->current_round, $this->subj->get_id(), $phase);
            }
            
            // if this is the last round in phase one move to intro phase two
            if($next_round_index == count($rounds)){
                $this->subj->set_current_phase('intro_phase_two');
                redirect('subject/intro_phase_two');
            }

            $this->subj->set_current_round($rounds[$next_round_index]);

            $round = $this->exp->get_phase_one_round_by_id($this->subj->current_round);
            if($round['round_type'] == 'parent' || $round['round_type'] == 'single'){
                $this->subj->increment_round_counter();
            }

            redirect('subject/phase_one', 'location');
        }

        /**
         * Adds the selected bundle to the database
         * @return <type>
         */
        private function _add_selected_bundle(){
            $selected_bundle_id = $this->input->post('bundle_id');
            $round_id = $this->data['round']['id'];
            $subject_id = $this->subj->get_id();

            // set disabled button for special round where parent has 3 children
            if($this->subj->current_round === '49'){
                $special_rounds = array(60=>array(),62=>array(),64=>array());

                $child_rounds = array(
                	60=>array(179, 180, 181, 182),
                	62=>array(187, 188, 189, 190),
                	64=>array(195, 196, 197, 198));
                
                // remove the bundle that was selected
                $parent_bundles = array(143=>0, 144=>1, 145=>2, 146=>3);
                
                $parent_selected_bundle_index = $parent_bundles[$selected_bundle_id];
                                
                // remove parent selected bundle from all children
                foreach($child_rounds as $round_key=>$bundle_values){
                	foreach($bundle_values as $bundle_key=>$bundle_value){	
                		if( $bundle_key == $parent_selected_bundle_index){
                			$selected_bundles[] = array('round_id'=>$round_key, 'bundle_id'=>$bundle_value);
                		}
                	}
                }
                
                foreach($child_rounds as &$bundle_value){
                	unset($bundle_value[$parent_selected_bundle_index]);
                }
                
                $bundle_index = 1; 
                foreach($child_rounds as $child_round_id=>$child_bundles){
                	$select_index = 1;
                	foreach($child_bundles as $bundle_id){
                		if($bundle_index == $select_index){
                			$selected_bundles[] = array('round_id'=>$child_round_id, 'bundle_id'=>$bundle_id);
                			++$bundle_index;
                			++$select_index;
                			break 1;
                		}else{
                			++$select_index;
                		}
                		
                	}
                }


                foreach($selected_bundles as $disabled_bundles){
                    $disabled_bundles_by_round[] = array('subject_id'=>$subject_id, 'round_id'=>$disabled_bundles['round_id'], 'bundle_id'=>$disabled_bundles['bundle_id']);
                }

                $this->exp->insert_phase_one_conditional_round($disabled_bundles_by_round);
            }

            return $this->exp->insert_phase_one_selected_bundle($round_id, $subject_id, $selected_bundle_id);
        }


        /**
         * Sets form validation rules for the bundle selection form
         */
        private function _set_form_validation() {
            $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

            $this->form_validation->set_rules('bundle_id', 'Bundle Selection', 'trim|required|integer|callback__validate_bundle_id');
        }

        /**
         * Validates the bundle selection ID
         * @param string $bundle_id
         * @return boolean
         */
        public function _validate_bundle_id($bundle_id){
            $bundle_id_valid = false;
            foreach($this->data['bundles'] as $bundle){
                if($bundle['id'] == $bundle_id && $bundle['availability']){
                    $bundle_id_valid = true;
                    break;
                }
            }

            if(!$bundle_id_valid){
               $this->form_validation->set_message('_validate_bundle_id', 'Invalid bundle selected');
               return false;
            }

            return true;
        }

        /**
         * Retrieves and prepares the data for display
         * @return <type>
         */
        private function _get_form_data(){
            $data['round'] = $this->exp->get_phase_one_round_by_id($this->subj->current_round);
            $data['question_id'] = $this->exp->get_question_id($this->subj->current_round);
            $data['question'] = $this->_construct_question($data['question_id'], $data['round']);
            
            $round_id = (int)$this->subj->current_round;
            
            $parent_round_id = $this->exp->get_parent_round_id($data['round'], $round_id);
        	
        	// if the parent_id is set use it instead of the child round_id
        	$round_id = (empty($parent_round_id))?$round_id:$parent_round_id;

        	$data['bundles'] = $this->exp->get_bundles($data['round'], (int)$this->subj->current_round, $this->subj->get_id());
	
        	$data['previously_selected_bundle'] = array();
        	if(isset($data['round']['parent_id'])){
        		$data['previously_selected_bundle'] = $this->exp->get_previously_selected_bundle($data['round'], (int)$data['round']['parent_id'], $this->subj->get_id());
        	}
       	
            shuffle(&$data['bundles']);
			
            // set bundle availability
            $number_of_bundles = count($data['bundles']);
            foreach($data['bundles'] as &$bundle){
                $data['items'][] = $this->exp->get_phase_one_bundle_items($bundle['id']);     
                $bundle_conditionally_unavailable = $this->exp->is_bundle_conditionally_unavailable($round_id, (int)$this->subj->get_id(), $bundle, $data['previously_selected_bundle']);
                
               if($bundle_conditionally_unavailable == true){
               	 	$bundle['availability'] = false;
               }elseif((isset($data['previously_selected_bundle']['bundle_id']) && ($data['previously_selected_bundle']['bundle_id'] + $number_of_bundles) == $bundle['id'])){
               		if($round_id != 22 && $round_id != 26 && $round_id != 60 && $round_id != 62 && $round_id != 64){
               			$bundle['availability'] = false;
               		}
               }
            }
            
            $data['bundle_descriptions'] = $this->_construct_bundle_descriptions($data['bundles'], $data['items']);

            return $data;
        }    
        

        /**
         * Sets the current round ID if this is the first round
         * @param <type> $index
         */
        private function _set_first_round($index = 0){
            $rounds = $this->subj->first_stage_order;
            $this->subj->set_current_round($rounds[$index]);
        }

        /**
         * Redirects the subject based upon his current_phase value.
         * @return boolean
         */
         private function _redirect_if_required(){

            if($this->subj->current_phase === 'phase_one'){
                return true;
            }

            if($this->subj->current_phase !== 'phase_one'){
                $this->_redirect($this->subj);
            }
        }

        /**
         * Constructs the round question.
         * @param integer $question_id
         * @param array $round
         * @return string
         */
        private function _construct_question($question_id, array $round){

            $question_text = $this->exp->get_question_str($question_id);

            $round_number = $this->subj->get_current_round_index() + 1;

            switch($round['round_type']){
                case 'parent':
                    $sub_round_number = '-1st Stage: ';
                    break;
                case 'child':
                    $sub_round_number = '-2nd Stage: ';
                    break;
                case 'single':
                    $sub_round_number = ' ';
                    break;
            }
            //$current_round = "<p>".$this->subj->current_round."</p>";
            return " R".$this->subj->round_counter.$sub_round_number.$question_text;

        }

        private function _contruct_bundle_strings(array $bundles){

            if(empty($bundles)){
                return false;
            }

            // construct string
            $bundle_strings = array();
            foreach($bundles as $bundle){
                $bundle_str = '';
                foreach($bundle as $item){
                    $bundle_str .= $item['item_number']. " ". $item['item_type'];
                    $bundle_str .=(next($bundle))?" AND ":"";
                }
                $bundle_strings[] = $bundle_str;
            }

            return $bundle_strings;
        }

        /**
         * Returns an array of bundle descriptions.
         * @param array $bundles
         * @param array $items
         * @return array
         */
        private function _construct_bundle_descriptions(array $bundles, array $items){
            $bundle_str = '';
            $bundle_descriptions = array();

            for($i = 0; $i < count($bundles); ++$i){
                $items_row = $items[$i];

                $bundle_str = '';

                for($j = 0; $j < count($items_row); ++$j){
                    $item = $items_row[$j];
                    $bundle_str .= $item['item_number']." ".$item['item_type'] . ((count($items_row) - 1 != $j)?" AND ":"");
                }

                $bundle_descriptions[$i] = $bundle_str;
            }

            return $bundle_descriptions;
        }

    }
