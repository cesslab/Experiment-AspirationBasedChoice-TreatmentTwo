<?php
/**
 * Experimenter Login Controller
 */
class Manage_experiment extends My_Controller {

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

        // retrieve the experiment id from the url
       $experiment_id = (int)$this->uri->rsegment(3,0);
       if(empty($experiment_id) || !is_integer($experiment_id)){
           return;
       }

       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $this->data['subjects'] = $this->experimenter->get_subjects($select);
       
       // if the experiment_id was invalid or has 0 subjects exit
       if(empty($this->data['subjects'])){
           return;
       }

        $this->data['experiment_id'] = $experiment_id;

       $select = new Select();
       $select->set_where(array('id'=>$experiment_id));
       $experiments = $this->experimenter->get_experiments($select);
       $this->data['experiments'] = $experiments;
       
       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $outcomes = $this->experimenter->get_outcome($select);
       $this->data['outcomes'] = $outcomes;

       $this->data['phase_one_button_str'] = ($experiments[0]['start_phase_one'])?"Stop Phase One":"Start Phase One";
       $this->data['phase_one_set'] = ($experiments[0]['start_phase_one'])?'true':'false';
       $this->data['phase_two_button_str'] = ($experiments[0]['start_phase_two'])?"Stop Phase Two":"Start Phase Two";
       $this->data['phase_two_set'] = $experiments[0]['start_phase_two']?'true':'false';

        // form post not valid/ or not posted
       $this->_set_form_validation();
        if(!$this->form_validation->run()){
             $this->load->view('experimenter/manage_experiment',$this->data);
             return;
        }

        if($this->input->post('phase_one_set')){
            $insert = new Insert();
            $insert->set_where(array('id'=>$experiment_id));
            // toggle phase one state
            $insert->set_row_data(array('start_phase_one'=>(!$experiments[0]['start_phase_one'])));
            $this->experimenter->update_experiment($insert);
        }

        if($this->input->post('phase_two_set')){
            $insert = new Insert();
            $insert->set_where(array('id'=>$experiment_id));
            //toggle phase two state
            $insert->set_row_data(array('start_phase_two'=>(!$experiments[0]['start_phase_two'])));
            $this->experimenter->update_experiment($insert);
        }

       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $this->data['experiment_id'] = $experiment_id;
       $this->data['subjects'] = $this->experimenter->get_subjects($select);

        $select = new Select();
       $select->set_where(array('id'=>$experiment_id));
       $experiments = $this->experimenter->get_experiments($select);
       $this->data['experiments'] = $experiments;      

       $this->data['phase_one_button_str'] = ($experiments[0]['start_phase_one'])?"Stop Phase One":"Start Phase One";
       $this->data['phase_one_set'] = ($experiments[0]['start_phase_one'])?'true':'false';
       $this->data['phase_two_button_str'] = ($experiments[0]['start_phase_two'])?"Stop Phase Two":"Start Phase Two";
       $this->data['phase_two_set'] = $experiments[0]['start_phase_two']?'true':'false';

       $this->load->view('experimenter/manage_experiment', $this->data);
    }

    public function get_experiment_subjects_table(){
         // retrieve the experiment id from the url
       $experiment_id = (int)$this->uri->rsegment(3,0);
       if(empty($experiment_id) || !is_integer($experiment_id)){
           return;
       }

       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $this->data['subjects'] = $this->experimenter->get_subjects($select);

       // if the experiment_id was invalid or has 0 subjects exit
       if(empty($this->data['subjects'])){
           return;
       }

        $this->data['experiment_id'] = $experiment_id;

       $select = new Select();
       $select->set_where(array('id'=>$experiment_id));
       $experiments = $this->experimenter->get_experiments($select);
       $this->data['experiments'] = $experiments;
       
       $select = new Select();
       $select->set_where(array('experiment_id'=>$experiment_id));
       $outcomes = $this->experimenter->get_outcome($select);
       $this->data['outcomes'] = $outcomes;

        $this->load->view('experimenter/experiment_subjects_table', $this->data);
    }


    private function _set_form_validation() {
            $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

            $this->form_validation->set_rules('start_phase_one', 'Start phase one', 'is_bool');
            $this->form_validation->set_rules('start_phase_two', 'Start phase two', 'is_bool');


    }
}