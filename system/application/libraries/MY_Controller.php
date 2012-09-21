<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class MY_Controller extends Controller{

    protected $subj; // subject
    protected $exp; // experiment
    protected $subj_session_data = array();

    protected $data = array();

    public function __construct(){
        parent::Controller();
    }

    /**
     * Returns an array indexed by (id, login, auth, and experiment_id)
     * @return array
     */
    protected function _get_subject_session_data(){
        $session_data = array(
            'id'=> $this->session->userdata('id'),
            'login'=>$this->session->userdata('login'),
            'auth'=>$this->session->userdata('auth'),
            'experiment_id'=>$this->session->userdata('experiment_id')
        );

        return $session_data;
    }

    protected function _get_experimenter_session_data(){
        $session_data = array(
            'id'=> $this->session->userdata('id'),
            'login'=>$this->session->userdata('login'),
            'auth'=>$this->session->userdata('auth'),
        );

        return $session_data;
    }

    protected function _redirect(Subject $subject){
        switch($subject->current_phase){
            case 'intro_phase_one':
                redirect('subject/intro_phase_one');
                break;
            case 'phase_one':
                redirect('subject/phase_one');
                break;
            case 'intro_phase_two':
                redirect('subject/intro_phase_two');
                break;
            case 'phase_two':
                redirect('subject/phase_two');
                break;
            case 'payoff':
                redirect('subject/payoff');
                break;
            case 'completed':
                $this->session->sess_destroy();
                redirect('subject/login');
                break;
            default:
                $this->session->sess_destroy();
                redirect('subject/login');
        }
    }
}