<?php
/**
 * Experimenter Login Controller
 */
class Manage_experiments extends My_Controller {

    public $experimenter;

    function  __construct() {
        parent::Controller();
        $this->data['error'] = '';

        $this->experimenter_session_data = $this->_get_experimenter_session_data();

            $this->experimenter = new Experimenter(
                    $this->experimenter_session_data['id'],
                    $this->experimenter_session_data['login'],
                    $this->experimenter_session_data['auth']);

            if(!$this->experimenter->authenticate()){
                $this->session->sess_destroy();
                redirect('experimenter/login');
            }
    }

    public function index(){

        // get all experiments
       $select = new Select();
       $experiments = $this->experimenter->get_experiments($select);
       $this->data['experiments'] = $experiments;

       // set the form validation rules and test them
       $this->_set_form_validation();
        // form post not valid/ or not posted
       if(!$this->form_validation->run()){
           $this->load->view('experimenter/manage_experiments', $this->data);
           return;
       }

       $experiment_id = $this->input->post('id');

       redirect('experimenter/manage_experiment/'.$experiment_id."/");
    }


    private function _set_form_validation() {
            $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

            $this->form_validation->set_rules('id', 'Number of Subjects', 'trim|required|integer');
    }
}