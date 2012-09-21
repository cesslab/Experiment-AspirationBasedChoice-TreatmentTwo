<?php
/**
 * Experimenter Login Controller
 */
class Experiment_output extends My_Controller {

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
       
       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $subjects = $this->experimenter->get_subjects($select);
       
       // if the experiment_id was invalid or has 0 subjects exit
       if(empty($subjects)){
           return;
       }
       
       $select = new Select();
       $select->set_where(array('id'=>$experiment_id));
       $experiment = $this->experimenter->get_experiments($select);
       
       $csv_file = BASEPATH.'../assets/output'.'/output-exp-'.$experiment_id.'.csv';
       $this->data['csv_file'] = $csv_file;
       $this->data['file_name'] = 'output-exp-'.$experiment_id.'.csv';
       $fp = fopen($csv_file, 'w');
       
       $experiment_key = array_keys($experiment[0]);
       fputcsv($fp, array("Experiment"));
       fputcsv($fp, $experiment_key);
       foreach($experiment as $exp){
       	fputcsv($fp, $exp);
       }
       
       // add subjects table to scv_file
       $subject_keys = array_keys($subjects[0]);
       fputcsv($fp, array("Subjects"));
       fputcsv($fp, $subject_keys);
		foreach ($subjects as $subject) {		
		    fputcsv($fp, $subject);
		}
       
		
		$selected_bundles = $this->experimenter->get_selected_bundles($experiment_id);
		if(!empty($selected_bundles)){
		$bundles_key = array_keys($selected_bundles[0]);
        fputcsv($fp, array("Subjects Selected Bundles"));
        fputcsv($fp, $bundles_key);
    	foreach($selected_bundles as $selected_bundle){
       		fputcsv($fp, $selected_bundle);
       }
		}
       
       $min_compensations = $this->experimenter->get_minimum_compensation($experiment_id);
       if(!empty($min_compensations)){
       $min_comp_keys = array_keys($min_compensations[0]);
       fputcsv($fp, array("Minimum Compensations"));
       fputcsv($fp, $min_comp_keys);
       foreach($min_compensations as $min_comp){
       	fputcsv($fp, $min_comp);
       }
       }
       
       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $outcomes = $this->experimenter->get_outcome($select);
    	if(!empty($outcomes)){
       $outcome_keys = array_keys($outcomes[0]);
       fputcsv($fp, array("Subjects Payoff"));
       fputcsv($fp, $outcome_keys);
       foreach($outcomes as $outcome){
       	fputcsv($fp, $outcome);
       }
    	}
       
		$conditional_unavail = $this->experimenter->general_query("select * from after_one_conditional");
    	if(!empty($conditional_unavail)){
		$cond_keys = array_keys($conditional_unavail[0]);
       fputcsv($fp, array("Conditionally Unavailble bundles for Hard Coded Rounds"));
       fputcsv($fp, $cond_keys);
       foreach($conditional_unavail as $cu){
       	fputcsv($fp, $cu);
       }	
    	}
    	
       fclose($fp);
       
       $this->load->view('experimenter/experiment_output', $this->data);
    }
}