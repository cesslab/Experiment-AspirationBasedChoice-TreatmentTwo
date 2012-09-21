<?php
    class intro_phase_one extends MY_Controller{
        
        

        function  __construct() {
            parent::__construct();

            $this->subj_session_data = $this->_get_subject_session_data();

            $this->subj = new Subject(
                    $this->subj_session_data['id'],
                    $this->subj_session_data['login'],
                    $this->subj_session_data['auth'],
                    $this->subj_session_data['experiment_id']);

            if(!$this->subj->authenticate()){
                $this->session->sess_destroy();
                redirect('subject/login');
            }

            $this->exp = new Experiment($this->subj_session_data['experiment_id']);
            
            if($this->subj->current_phase === 'not_logged_in'){
            	$this->subj->set_current_phase('intro_phase_one');         	
            }

            $this->_redirect_if_required();
            
            $this->output->set_header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
           	$this->output->set_header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0"); 
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0"); 
			$this->output->set_header("Pragma: no-cache");  
        }

        public function index(){   
            // Permutate the rounds for the specified treatment, if required.
            if($this->subj->first_stage_order === ''){
                switch($this->exp->treatment){
                    case "After":
                        $permutated_round = $this->exp->get_phase_one_permutated_rounds();
                        $this->subj->set_last_round($permutated_round);
                        $this->subj->set_round_order($permutated_round);
                        break;
                    case "Before":
                        break;
                }
            }
            
            $this->load->view('subject/intro_phase_one', $this->data);
        }
        
        /**
         * Redirects the subject to the appropriate stage if this
         * is not the correct stage.
         */
        private function _redirect_if_required(){
         /*
          *  Case when a subject should stay in intro_phase_one:
          *  1. The current phase is set to intro_phase_one and
          *     the start_phase_one flag has not been set to true.
          */
            if($this->subj->current_phase === 'intro_phase_one' && $this->exp->start_phase_one == false){
                return true;
            }


            /*
          *  Case when a subject should move to another stage:
          *  1. The current phase is intro_phase_one and the start_phase_one flag is set to true.
          *  2. The current phase is not set to intro_phase_one.
          */
            if($this->subj->current_phase === 'intro_phase_one' && $this->exp->start_phase_one == true){
                $this->subj->set_current_phase('phase_one');
                $this->_redirect($this->subj);
            }
            elseif($this->subj->current_phase !== 'intro_phase_one'){
                $this->_redirect($this->subj);

            }
            
        }
    }