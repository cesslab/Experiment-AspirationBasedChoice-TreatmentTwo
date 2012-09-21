<?php
/**
 * Experimenter Login Controller
 */
class Login extends Controller {

    private $data = array();

    function  __construct() {
        parent::Controller();
        $this->data['error'] = '';

        // TODO: Use the Experimenter class for this (got to keep the controller thin!
        if($this->_is_already_logged_in()){
            $this->_forward_to_home_page();
        }
    }

    public function index(){
        // Validate form on POST, or render login form on get.
        $this->_set_form_validation();
        if(!$this->form_validation->run()){
             $this->load->view('experimenter/login', $this->data);
             return;
        }

        $select = new Select();
        $select->set_where($this->_get_experimenter_login_data());
        
        $experimenter = new Experimenter();
        $selected_subject = $experimenter->get_experimenter($select);

        // Invalid login or password
        if(empty($selected_subject)){
            $this->data['error'] = "You entered an invalid login and password, please try again.";
            $this->load->view('experimenter/login', $this->data);
            return;
        }

        $this->session->set_userdata('id', $selected_subject[0]['id']);
        $this->session->set_userdata('login', $selected_subject[0]['login']);
        $this->session->set_userdata('auth','experimenter');

        redirect('experimenter/home');
    }

    /**
     * Sets login form validation rules
     */
    private function _set_form_validation() {
        $this->form_validation->set_error_delimiters('<label id="error">', '</label>');

        $this->form_validation->set_rules('login', 'Login', 'trim|required|validate_login');
        $this->form_validation->set_rules('password', 'Password', 'trim|required|validate_password');
    }  

    private function _get_experimenter_login_data() {
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

        if(!empty($id) && !empty($login) && !empty($auth) && $auth === 'experimenter'){
            return true;
        }

        return false;
    }

    private function _forward_to_home_page(){
        $auth = $this->session->userdata('auth');
        if( $auth === 'experimenter'){
            redirect('experimenter/home');
        }
    }
}
