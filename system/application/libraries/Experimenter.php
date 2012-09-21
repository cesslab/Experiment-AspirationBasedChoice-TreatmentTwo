<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Experimenter {

    private $CI;

    private $id = '';
    private $login = '';
    private $auth = '';
   
    private $experimenter_data = array();

    /**
     * Initializes the Experimenter authentication properties & loads
     * the necessary models.
     *
     * @param string $id (numeric)
     * @param string $login
     * @param string $auth
     */
    function  __construct($id = '', $login = '', $auth = '') {
        $this->CI = &get_instance();

        $this->id = (!empty($id) && is_numeric($id))?$id:'';
        $this->login =(!empty($login) && is_string($login))?$login:'';
        $this->auth =(!empty($auth) && is_string($auth))?$auth:'';
       
        $this->CI->load->model('Experimenter_model');
        $this->CI->load->model('Experiment_model');
        $this->CI->load->model('Subject_model');
        $this->CI->load->model('Outcome_model');
        $this->CI->load->model('General_model');

        if($this->authenticate()){
            $this->experimenter_data = $this->get_state_info();
        }


    }

    /**
     * Retrieves values from the property $experiment_data array if
     * they exist.
     * @param string $name
     * @return mixed
     */
    public function __get($name) {
        if($name === 'first_stage_order'){
            if(array_key_exists($name, $this->experimenter_data) && !empty($this->experimenter_data['first_stage_order'])){
                return explode(',', $this->experimenter_data['first_stage_order']);
            }
        }elseif($name === 'second_stage_order'){
            if(array_key_exists($name, $this->experimenter_data) && !empty($this->experimenter_data['second_stage_order'])){
                return explode(',', $this->experimenter_data['second_stage_order']);
            }
        }

        if (array_key_exists($name, $this->experimenter_data)) {
            return $this->experimenter_data[$name];
        }
    }

    /**
     * Insert a subject record with Insertion data.
     * @param Insert $insert
     * @return integer
     */
    private function add_subject(Insert $insert){
        return $this->CI->Subject_model->add($insert);
    }


    /**
     *  Retrieves Experimenter(s) record from the Experimenter table, qualified by the
     *  $selection and $where options.
     *
     * @param array $select
     * @param mixed $where array or string
     * @param boolean $return_type
     */
    public function get_experimenter(Select $select){
        return $this->CI->Experimenter_model->get($select);
    }
    
    public function general_query($query = ''){
    	return $this->CI->General_model->query($query);
    }

    public function get_experiments(Select $select){
        return $this->CI->Experiment_model->get($select);
    }

     public function get_subjects(Select $select){
        return $this->CI->Subject_model->get($select);
    }
    
     public function get_outcome(Select $select){
        return $this->CI->Outcome_model->get($select);
    }
    
    public function get_experiment_outcome($experiment_id = 0){
    	$select = new Select();
    	$select->set_where(array('experiment_id'));
    	$result = $this->get_outcome($select);
    	
    	if(empty($result)){
    		return false;
    	}
    	
    	return $result;
    }
    
    public function get_selected_bundles($experiment_id = 0){
    	if(empty($experiment_id)){
    		return false;
    	}
    	
    	$query = sprintf("select subjects.experiment_id as experiment_id, subjects.id as subject_id,".
    		" after_selected_bundles.round_id as round_id, after_selected_bundles.bundle_id as bundle_id ".
    		"from subjects left join after_selected_bundles on(subjects.id = after_selected_bundles.subject_id) having experiment_id = %s order by subject_id", $experiment_id);
    	
    	$result = $this->general_query($query);
    	
    	if(empty($result)){
    		return false;
    	}
    	
    	return $result;
    }
    
    public function get_minimum_compensation($experiment_id = 0){
    	if(empty($experiment_id)){
    		return false;
    	}
    	
    	$query = sprintf("select subjects.experiment_id, minimum_compensation.* from subjects left join minimum_compensation on (subjects.id = minimum_compensation.subject_id) where experiment_id = %s", $experiment_id);
    	
    	$result = $this->general_query($query);
    	
    	if(empty($result)){
    		return false;
    	}
    	
    	return $result;
    }

    /**
     * Update a subject record with Insertion data.
     * @param Insert $insert
     * @return <type>
     */
    public function update_experiment(Insert $insert){
        $result = $this->CI->Experiment_model->update($insert);

        return $result;
    }

    /**
     * Insert a Experimenter record with Insertion data.
     * @param Insert $insert
     * @return integer
     */
    public function add_experimenter(Insert $insert){
        return $this->CI->Experimenter_model->add($insert);
    }

    /**
     * Update a Experimenter record with Insertion data.
     * @param Insert $insert
     * @return <type>
     */
    public function update_experimenter(Insert $insert){
        $result = $this->CI->Experimenter_model->update($insert);

        $this->experimenter_data = $this->get_state_info();

        return $result;
    }

    private function add_experiment(Insert $insert){
        $experiment_id = $this->CI->Experiment_model->add($insert);

        $this->experiment_data = $this->get_state_info();

        return $experiment_id;
    }

    public function insert_experiment(array $values){
        $insert = new Insert();
        $insert->set_row_data($values);

        return $this->add_experiment($insert);
    }

    public function insert_subject(array $values){
        $insert = new Insert();
        $insert->set_row_data($values);

        $subject_id = $this->add_subject($insert);

        return $subject_id;
    }

    public function get_state_info(){
        // get subject data
        $select = new Select();
        $select->set_where(array('id'=>$this->id));
        $experimenter_data = $this->get_experimenter($select);

        if(empty($experimenter_data)){
            return false;
        }

        return $experimenter_data[0];
    }


    /**
     * Authenticates the Experimenter given the initialized properties.
     * @return boolean.
     */
    public function authenticate(){
        if(empty($this->id) || empty($this->login) || empty($this->auth) ){
            return false;
        }

        if($this->auth !== 'experimenter'){
            return false;
        }

        $select = new Select();
        $select->set_where(array('id'=>$this->id, 'login'=>$this->login));
        $experimenter = $this->get_experimenter($select);

        if(empty($experimenter) || count($experimenter) != 1){
            return false;
        }

        return true;
    }

    /**
     * Returns the Experimenter ID
     * @return integer
     */
    public function get_id(){
        return $this->id;
    }

    /**
     * Returns the Experimenter login
     * @return string
     */
    public function get_login(){
        return $this->login;
    }
}
