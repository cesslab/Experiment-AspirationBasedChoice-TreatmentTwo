<?php
/**
 * Experimenter Login Controller
 */
class Add_experiment extends My_Controller {

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
            $this->_set_form_validation();

            $this->data['treatment'] = array('After'=>'After', 'Before'=>'Before');

            // form post not valid/ or not posted
            if(!$this->form_validation->run()){
                 $this->load->view('experimenter/add_experiment', $this->data);
                 return;
            }

            $num_subjects = $this->input->post('num_subjects');
            $treatment = $this->input->post('treatment');

            $experiment_values = array(
                'num_subjects'=>$num_subjects,
                'treatment'=>$treatment,
                'showupfee'=>$this->input->post('showupfee')
            );

            // insert experiment & get ID
            $experiment_id = $this->experimenter->insert_experiment($experiment_values);

            // confirm experiment creation
            if(empty($experiment_id)){
                return;
            }

            // create subjects login, password, and insert into database
            for($i = 0; $i < $num_subjects; ++$i){
                $login =$this->_generate_login();
                $subject_info = array(
                    'login' => $login.$experiment_id,
                    'password' => md5($login.$experiment_id.'0011'),
                    'experiment_id' => $experiment_id,
                    'treatment'=>$treatment
                    );
                $this->experimenter->insert_subject($subject_info);
            }

            $this->data['num_subjects_added'] = $i;
            $this->data['experiment_id'] = $experiment_id;

       $this->load->view('experimenter/subjects_added', $this->data);
    }

    private function _generate_login($syllables = 3, $use_prefix = true){

	    // Define function unless it is already exists
	    if (!function_exists('ae_arr'))
	    {
	        // This function returns random array element
	        function ae_arr(&$arr)
	        {
	            return $arr[rand(0, sizeof($arr)-1)];
	        }
	    }

	    // 20 prefixes
	    $prefix = array('aero', 'anti', 'auto', 'bi', 'bio',
	                    'cine', 'deca', 'demo', 'dyna', 'eco',
	                    'ergo', 'geo', 'gyno', 'hypo', 'kilo',
	                    'mega', 'tera', 'mini', 'nano', 'duo');

	    // 10 random suffixes
	    $suffix = array('dom', 'ity', 'ment', 'sion', 'ness',
	                    'ence', 'er', 'ist', 'tion', 'or');

	    // 8 vowel sounds
	    $vowels = array('a', 'o', 'e', 'i', 'y', 'u', 'ou', 'oo');

	    // 20 random consonants
	    $consonants = array('w', 'r', 't', 'p', 's', 'd', 'f', 'g', 'h', 'j',
	                        'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'qu');

	    $password = $use_prefix?ae_arr($prefix):'';
	    $password_suffix = ae_arr($suffix);

	    for($i=0; $i<$syllables; $i++)
	    {
	        // selecting random consonant
	        $doubles = array('n', 'm', 't', 's');
	        $c = ae_arr($consonants);
	        if (in_array($c, $doubles)&&($i!=0)) { // maybe double it
	            if (rand(0, 2) == 1) // 33% probability
	                $c .= $c;
	        }
	        $password .= $c;
	        //

	        // selecting random vowel
	        $password .= ae_arr($vowels);

	        if ($i == $syllables - 1) // if suffix begin with vovel
	            if (in_array($password_suffix[0], $vowels)) // add one more consonant
	                $password .= ae_arr($consonants);

	    }

	    // selecting random suffix
	    $password .= $password_suffix;

	    return $password;
    }

    private function _set_form_validation() {
            $this->form_validation->set_error_delimiters('<label id="error">', '</label>');
            $this->form_validation->set_rules('treatment', 'Treatment', 'trim|requried');
            $this->form_validation->set_rules('num_subjects', 'Number of Subjects', 'trim|required|integer');
            $this->form_validation->set_rules('showupfee', 'Show-up-fee', 'trim|required|is_numeric');
    }


}