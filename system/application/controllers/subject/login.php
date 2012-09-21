<?php
/**
 * Subject Login Controller
 */
class Login extends Controller {

    private $data = array();

    function  __construct() {
        parent::Controller();
        $this->data['error'] = '';

        // TODO: Use the Subject class for this (got to keep the controller thin!
        if($this->_is_already_logged_in()){
            $this->session->sess_destroy();
        }
            $this->output->set_header("Expires: Tue, 01 Jan 2000 00:00:00 GMT");
           	$this->output->set_header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
			$this->output->set_header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0"); 
			$this->output->set_header("Cache-Control: post-check=0, pre-check=0"); 
			$this->output->set_header("Pragma: no-cache"); 
    }

    public function index(){
        // Validate form on POST, or render login form on get.
        $this->_set_form_validation();
        if(!$this->form_validation->run()){
             $this->load->view('subject/login', $this->data);
             return;
        }

        $select = new Select();
        $select->set_where($this->_get_subject_login_data());
        
        $subject = new Subject();
        $selected_subject = $subject->get_subjects($select);

        // Invalid login or password
        if(empty($selected_subject)){
            $this->data['error'] = "You entered an invalid login and password, please try again.";
            $this->load->view('subject/login', $this->data);
            return;
        }

         // Only subjects participating in the Before treatment are allowed
        if($selected_subject[0]['treatment'] !== 'After'){
            return;
        }

        $this->session->set_userdata('id', $selected_subject[0]['id']);
        $this->session->set_userdata('login', $selected_subject[0]['login']);
        $this->session->set_userdata('experiment_id', $selected_subject[0]['experiment_id']);
        $this->session->set_userdata('auth','subject');

        redirect('subject/intro_phase_one');
    }

    /**
     * Sets login form validation rules
     */
    private function _set_form_validation() {
        $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

        $this->form_validation->set_rules('login', 'Login', 'trim|required|validate_login');
        $this->form_validation->set_rules('password', 'Password', 'trim|required|validate_password');
    }  

    private function _get_subject_login_data() {
        return array(
            'login'=>$this->input->post('login'),
            'password'=>md5($this->input->post('password'))
        );
    }

    private function _is_already_logged_in(){
        // can't use return value in write context so I have to do this, Agh!!!
        $id = $this->session->userdata('id');
        $login = $this->session->userdata('login');
        $auth = $this->session->userdata('auth');

        if(!empty($id) && !empty($login) && !empty($auth) && $auth === 'subject'){
            return true;
        }

        return false;
    }

    private function _forward_to_home_page(){
        $auth = $this->session->userdata('auth');
        if( $auth === 'subject'){
            redirect('subject/intro_phase_one');
        }
        elseif($auth === 'experimenter'){
            redirect('experimenter/home');
        }
    }
}
