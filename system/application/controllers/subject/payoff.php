<?php
    class payoff extends MY_Controller{
    	
    	private $bundle_id_counter = 101;

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
            $this->output->set_header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
           	$this->output->set_header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0"); 
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0"); 
			$this->output->set_header("Pragma: no-cache"); 
        }
	
        public function index(){
            // is payoff empty, then determine, store, and display it
            $payoff = $this->subj->payoff;
            if(empty($payoff)){          
                $first_stage = $this->subj->first_stage_order;
                $second_stage = $this->subj->second_stage_order;

                $rounds_first_stage = count($first_stage);
                $rounds_second_stage = count($second_stage);

                $min_round_index = 0;
                $max_round_index = $rounds_first_stage + $rounds_second_stage - 1;
                $random_round_index = rand($min_round_index, $max_round_index);

                // Payoff if a first stage round was selected
                if($random_round_index < $rounds_first_stage){
                	
                    $random_round_id = $first_stage[($random_round_index)];

                    $this->data = $this->_set_phase_one_payoff_data($random_round_id);
                    $outcome_data = array(
                        'subject_id'=> $this->subj->get_id(),
                    	'experiment_id'=>$this->subj->experiment_id,
                        'phase_selected'=>'phase_one',
                        'round_id'=>$random_round_id,
                        'bundle_id'=>(isset($this->data['selected_bundle_id']))?$this->data['selected_bundle_id']:0,
                    	'bundle_desc'=>(isset($this->data['bundle_str']))?$this->data['bundle_str']:'',
                        'random_val'=>0,
                        'min_comp'=>0,
                    	'payoff'=>("$".$this->data['showupfee']. " + Bundle: (". $this->data['bundle_str'].")")
                    );

                    $this->exp->insert_outcome($outcome_data);
                    $this->subj->set_payoff($this->data['showupfee']);
                    $this->subj->set_current_phase('completed');

                    $this->session->sess_destroy();
                    $this->load->view('subject/phase_one_payoff', $this->data);

                } // Payoff if a second stage round was selected
                else{
                    $random_round_index = $random_round_index - $rounds_first_stage;
                    $random_round_id = $second_stage[($random_round_index-1)];
                    
                    $this->data = $this->_set_phase_two_payoff_data($random_round_id);

                    $outcome_data = array(
                        'subject_id'=> $this->subj->get_id(),
                    	'experiment_id'=>$this->subj->experiment_id,
                        'phase_selected'=>'phase_two',
                        'round_id'=>$random_round_id,
                        'bundle_id'=>$this->data['selected_bundle_id'],
                        'random_val'=>$this->data['random_compensation_amount'],
                        'min_comp'=>(($this->data['perfered_bundle_selected'])?0:(double)$this->data['selected_min_comp']),
                    	'bundle_desc'=>$this->data['selected_bundle_description'],
                    	'payoff'=>("$".$this->data['final_payoff']. " + Bundle: (".(($this->data['random_compensation_amount'] >= $this->data['selected_min_comp'])?$this->data['selected_bundle_description']:$this->data['prefered_bundle_description']).")")
                    );
                    
                    $this->exp->insert_outcome($outcome_data);
                    $this->subj->set_payoff($this->data['final_payoff']);
                    $this->subj->set_current_phase('completed');
                    
                    $this->session->sess_destroy();
                    $this->load->view('subject/phase_two_payoff', $this->data);
                }
            }
            
        }

        private function _set_phase_two_payoff_data($random_round_id){
            $phase_two_question_id = 5; 
			
            $random_compensation_amount = ((30-0.1)*lcg_value() + 0.1);
            
            // get the displayed round number and phase
            $displayed_round_number = $this->exp->get_displayed_round_id($this->subj->get_id(), $random_round_id, 2);
            $data['round_number'] = $displayed_round_number['displayed_round'];
            $data['phase'] = 'Phase 2 ';

            //$data['phase_one_round'] = $this->exp->get_phase_one_round_by_id($random_round_id);
            
            // get the bundle selected in the corresponding phase one round
            $data['phase_one_selected_bundle'] = $this->exp->get_phase_one_selected_bundle($random_round_id, $this->subj->get_id());
           
            // retrieve items for each bundle
            $phase_one_bundles = $this->exp->get_phase_one_round_bundles($random_round_id);
            foreach($phase_one_bundles as $bundle){
                if(((int)$bundle['id']) != ((int)$data['phase_one_selected_bundle']['bundle_id'])){
                    $min_comp = $this->exp->get_min_comp($bundle['id'], $this->subj->get_id());
                    $data['min_comp'][] = $min_comp['amount'];
                    $data['bundles'][] = $bundle;
                    $data['bundle_of_items'][] = $this->exp->get_phase_one_bundle_items($bundle['id']);
                }else{
                	$data['min_comp'][] = 0;
                }
            }
			
            // randomly select a bundle
            $num_bundles = count($phase_one_bundles) - 1;
            $rand_index = rand(0, $num_bundles);
           
			/*
			 * If the prefered bundle was selected set its id (selected_bundle_id) 
			 * and set the perfered_bundle_selected to true.
			 */
            $data['perfered_bundle_selected'] = false;
            if($phase_one_bundles[$rand_index]['id'] == (int)$data['phase_one_selected_bundle']['bundle_id']){
            	$data['selected_bundle_id'] = (int)$data['phase_one_selected_bundle']['bundle_id'];
            	$data['selected_min_comp'] = 0;
            	$data['perfered_bundle_selected'] = true;
            }else{
            	$data['selected_bundle_id'] = (int)$phase_one_bundles[$rand_index]['id'];
            	$data['selected_min_comp'] = $data['min_comp'][$rand_index];
            }
                        
            // get the selected bundle button
            $selected_bundle_items = $this->exp->get_phase_one_bundle_items($data['selected_bundle_id']);
            $data['selected_bundle_description'] = $this->_contruct_bundle_string($selected_bundle_items);
            $data['selected_bundle_button'] = $this->_construct_button($data['selected_bundle_description']);
 
            
            $data['showupfee'] = $this->exp->showupfee;
            
            if($data['perfered_bundle_selected']){
            	$data['payoff'] = 0;
            	$data['final_payoff'] = $this->exp->showupfee;
            }else{
            	$data['payoff'] = round((($random_compensation_amount >= ((double) $data['min_comp'][$rand_index]))?$random_compensation_amount:0), 2);
            	$data['final_payoff'] = $data['payoff'] + $this->exp->showupfee;
            	$data['receive_random_price'] = ($random_compensation_amount >= ((double) $data['min_comp'][$rand_index]))?true:false;
            }
 
            $data['random_compensation_amount'] = round($random_compensation_amount,2);
            
            // construct the selected bundle string
            $prefered_bundle_items = $this->exp->get_phase_one_bundle_items($data['phase_one_selected_bundle']['bundle_id']);
            $data['prefered_bundle_description'] = $this->_contruct_bundle_string($prefered_bundle_items);
            $data['prefered_bundle_button'] = $this->_construct_button($data['prefered_bundle_description']);
            
            $data['bundle_descriptions'] = $this->_contruct_bundle_strings($data['bundle_of_items']);

            return $data;
        }

        private function _set_phase_one_payoff_data($random_round_id){
            $data['round'] = $this->exp->get_phase_one_round_by_id($random_round_id);
            
            // get parent and child round ID
            $round_id = $random_round_id;
            $parent_round_id = (isset($data['round']['parent_id']) && !empty($data['round']['parent_id']))?(int)$data['round']['parent_id']:$round_id;
            
            // get the displayed round number
            $displayed_round_number = $this->exp->get_displayed_round_id($this->subj->get_id(), $parent_round_id, 1);
            $data['round_number'] = $displayed_round_number['displayed_round'];
             
            //get and set selected bundle for this round
            $selected_bundle = $this->exp->get_phase_one_selected_bundle($round_id, $this->subj->get_id());
            $data['selected_bundle_id'] = (int)$selected_bundle['bundle_id'];
            $selected_bundle_item = $this->exp->get_phase_one_bundle_items( $data['selected_bundle_id']);
            $data['bundle_str'] = $this->_contruct_bundle_string($selected_bundle_item);

            $data['stage'] = ($data['round']['round_type']==='parent' || $data['round']['round_type'] === 'single')?'1st':'2nd';
            $data['showupfee'] = $this->exp->showupfee;
            
			//get the bundles for this round
            $data['bundles'] = $this->exp->get_phase_one_round_bundles($random_round_id); 
            
        	$data['previously_selected_bundle'] = array();
        	if(isset($data['round']['parent_id'])){
        		$data['previously_selected_bundle'] = $this->exp->get_previously_selected_bundle($data['round'], $parent_round_id, $this->subj->get_id());
        	}
            
            // extract the bundles and their items
            $number_of_bundles = count($data['bundles']);
            foreach($data['bundles'] as &$bundle){
                $data['bundle_of_items'][] = $this->exp->get_phase_one_bundle_items($bundle['id']);
                
            	$bundle_conditionally_unavailable = $this->exp->is_bundle_conditionally_unavailable($round_id, (int)$this->subj->get_id(), $bundle, $data['previously_selected_bundle']);
                
               if($bundle_conditionally_unavailable == true){
               	 	$bundle['availability'] = false;
               }elseif((isset($data['previously_selected_bundle']['bundle_id']) && ($data['previously_selected_bundle']['bundle_id'] + $number_of_bundles) == $bundle['id'])){
               		if($round_id != 22 && $round_id != 26 && $round_id != 60 && $round_id != 62 && $round_id != 64){
               			$bundle['availability'] = false;
               		}
               }
            }
            $data['bundle_descriptions'] = $this->_contruct_bundle_strings($data['bundle_of_items']);
   
            return $data;
        }
               

        private function _construct_button($bundle_str){
        	
        	++$this->bundle_id_counter;
        	
            return sprintf('<input type="radio" class ="radio%d" id="radio%d" name="bundle_id" value="" /><label for="radio%d">%s</label>',
            $this->bundle_id_counter, $this->bundle_id_counter, $this->bundle_id_counter, $bundle_str);
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

        private function _contruct_bundle_string(array $bundle_of_items){
            if(empty($bundle_of_items)){
                return false;
            }

            // construct string
            $bundle_str = '';
            foreach($bundle_of_items as $item){
                $bundle_str .= $item['item_number']. " ".$item['item_type'];
                $bundle_str .=(next($bundle_of_items))?" AND ":"";
            }

            return $bundle_str;
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
       
        /**
         * Redirects the subject based upon his current_phase value.
         * @return boolean
         */
         private function _redirect_if_required(){
            if($this->subj->current_phase !== 'payoff'){
                $this->_redirect($this->subj);
            }

            return true;
        }

        private function _construct_question($question_id, array $round){

            $question_text = $this->exp->get_question_str($question_id);

            return $question_text;

        }


    }
