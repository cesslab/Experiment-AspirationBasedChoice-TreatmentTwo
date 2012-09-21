<?php
    class phase_two extends MY_Controller{

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
                $this->_set_second_round($index);
                $this->subj->set_current_round_index($index); // set to fist element in the array
            }
            elseif($this->subj->current_round != 0){
                $rounds = $this->subj->second_stage_order;
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

            $this->data = $this->_get_form_data();
            $this->_set_form_validation();

            if(!$this->form_validation->run()){
                 $this->load->view('subject/phase_two', $this->data);
                 return;
            }

            if(!$this->_add_minimum_compensation()){
                $this->load->view('subject/phase_two', $this->data);
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

            $rounds = $this->subj->second_stage_order;

            $round = $this->exp->get_phase_one_round_by_id($this->subj->current_round);
            $phase= 2;
            $this->exp->insert_displayed_round_id(($this->subj->round_counter+1), $this->subj->current_round, $this->subj->get_id(), $phase);
            
            // if this is the last round in phase one move to intro phase two
            if($next_round_index == count($rounds)){
                $this->subj->set_current_phase('payoff');
                redirect('subject/payoff');
            }

            $this->subj->set_current_round($rounds[$next_round_index]);

            $round = $this->exp->get_phase_one_round_by_id($this->subj->current_round);
            $this->subj->increment_round_counter();
            
            redirect('subject/phase_two');
        }

        /**
         * Adds the selected bundle to the database
         * @return <type>
         */
        private function _add_minimum_compensation(){
            $minimum_compensation = $this->input->post('minimum_compensation');
            $round_id = $this->data['round']['id'];
            $subject_id = $this->subj->get_id();

            return $this->exp->insert_phase_two_minimum_entries($minimum_compensation, $subject_id, $round_id);
        }


        /**
         * Sets form validation rules for the bundle selection form
         */
        private function _set_form_validation() {
            $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

            foreach($this->data['bundles'] as $bundle){
                $this->form_validation->set_rules('minimum_compensation['.$bundle['id'].']', 'Minimum value', 'trim|required|callback__validate_minimum_compensation_entry');
            }

        }

        public function _validate_minimum_compensation_entry($value){
            $min_val = (double) 0;
            $max_val = (double)200;

            $min_comp = $this->input->post('minimum_compensation');
            
            $key = array_search($value, $min_comp);
            if(empty($key)){
                $this->form_validation->set_message('_validate_minimum_compensation_entry', 'A number must be entered for each bundles.');
                return false;
            }

            // does this bundle really exist
            if(!isset($this->data['minimum_compensation_keys'][$key])){
                $this->form_validation->set_message('_validate_minimum_compensation_entry', 'A number must be entered for each bundles.');
                return false;
            }

            if(!is_numeric($value)){
                $this->form_validation->set_message('_validate_minimum_compensation_entry', 'A numeric values must be selected for each bundle.');
                return false;
            }

            $value = (double) $value;

            if( $value <= $min_val){
                $this->form_validation->set_message('_validate_minimum_compensation_entry', 'Please enter a positive amount.');
                return false;
            }elseif($value > $max_val){
            	$this->form_validation->set_message('_validate_minimum_compensation_entry', 'Please enter a positive amount less than ' . $max_val . '.');
                return false;
            }
                
            return true;
        }

        /**
         * Validates the bundle selection ID
         * @param string $bundle_id
         * @return boolean
         */
        public function _validate_bundle_id($bundle_id){
            $bundle_id_valid = false;
            foreach($this->data['bundles'] as $bundle){
                if($bundle['id'] == $bundle_id){
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
            $phase_two_question_id = 5; // only one question type for phase 2
            $phase_two_round_id = $this->subj->current_round;
            $data['round'] = $this->exp->get_phase_one_round_by_id($phase_two_round_id);
            $data['question'] = $this->_construct_question($phase_two_question_id);

            $bundles = $this->exp->get_phase_one_round_bundles($data['round']['id']);

            // when in doubt shuffle
            shuffle(&$bundles);

            $data['selected_bundle'] = $this->exp->get_phase_one_selected_bundle($data['round']['id'], $this->subj->get_id());

            // retrieve items for each bundle
            $displayed_bundles = array();
            $selected_bundle = array();
            foreach($bundles as &$bundle){
                if(isset($data['selected_bundle']) && $bundle['id'] != $data['selected_bundle']['bundle_id']){
                    $data['bundles'][] = $bundle;
                    $data['bundle_of_items'][] = $this->exp->get_phase_one_bundle_items($bundle['id']);
                    $data['minimum_compensation_keys'][$bundle['id']] = '';
                }else{
                    $selected_bundle = $this->exp->get_phase_one_bundle_items($bundle['id']);
                }
            }

            // construct the selected bundle string
            $bundle_str = $this->_contruct_bundle_string($selected_bundle);

            $bundle_str = $this->_construct_button($bundle_str);

            $data['bundle_descriptions'] = $this->_contruct_bundle_strings($data['bundle_of_items']);

            $data['question'] = preg_replace('/{bundle_chosen}/', $bundle_str, $data['question']);

            return $data;
        }

        private function _construct_button($bundle_str){
            return sprintf('<input type="radio" class ="radio100" id="radio100" name="bundle_id" value="" /><label for="radio100">%s</label>',$bundle_str);
        }

        /**
         * Sets the current round ID if this is the first round
         * @param <type> $index
         */
        private function _set_second_round($index = 0){
            $rounds = $this->subj->second_stage_order;
            return $this->subj->set_current_round($rounds[$index]);
        }

        /**
         * Redirects the subject based upon his current_phase value.
         * @return boolean
         */
         private function _redirect_if_required(){

            if($this->subj->current_phase === 'phase_two'){
                return true;
            }

            if($this->subj->current_phase !== 'phase_two'){
                $this->_redirect($this->subj);
            }
        }

        /**
         * Constructs the round question.
         * @param integer $question_id
         * @return string
         */
        private function _construct_question($question_id){

            $question_text = $this->exp->get_question_str($question_id);

            $round_number = $this->subj->get_current_round_index() + 1;

            //$current_round = $this->subj->current_round;
            return " R".$round_number.": ".$question_text;

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

    }
