<?php
/**
 * Experimenter Login Controller
 */
class View_data extends My_Controller {

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
    	
    	$experiment_id = (int)$this->input->post('experiment_id');
       if(empty($experiment_id) || !is_integer($experiment_id)){
           return;
       }

       $selected_bundles = $this->experimenter->get_selected_bundles($experiment_id);
       $this->data['bundles_selected'] = (empty($selected_bundles))?array():$selected_bundles;
       
       $min_comp_entries = $this->experimenter->get_minimum_compensation($experiment_id);
       $this->data['minimum_compensation_entries'] = (empty($min_comp_entries))?array():$min_comp_entries;
       
       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $outcome_entries = $this->experimenter->get_outcome($select);
       $this->data['outcome_entries'] = (empty($outcome_entries))?array():$outcome_entries;
       
       $this->load->view('experimenter/view_data', $this->data);
    }
 
}