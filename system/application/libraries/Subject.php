<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Subject {

    private $CI;

    private $id = '';
    private $login = '';
    private $auth = '';
    private $experiment_id = 0;
    private $current_round_index = 0;

    private $subject_data = array();

    /**
     * Initializes the Subject authentication properties & loads
     * the necessary models.
     *
     * @param string $id (numeric)
     * @param string $login
     * @param string $auth
     */
    function  __construct($id = '', $login = '', $auth = '', $experiment_id = 0) {
        $this->CI = &get_instance();
        
        $this->id = (!empty($id) && is_numeric($id))?$id:'';
        $this->login =(!empty($login) && is_string($login))?$login:'';
        $this->auth =(!empty($auth) && is_string($auth))?$auth:'';
        $this->experiment_id = (!empty($experiment_id))?$experiment_id:0;

        $this->CI->load->model('Subject_model');
        
        if($this->authenticate()){
            $this->subject_data = $this->get_state_info();
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
            if(array_key_exists($name, $this->subject_data) && !empty($this->subject_data['first_stage_order'])){
                return explode(',', $this->subject_data['first_stage_order']);
            }
        }elseif($name === 'second_stage_order'){
            if(array_key_exists($name, $this->subject_data) && !empty($this->subject_data['second_stage_order'])){
                return explode(',', $this->subject_data['second_stage_order']);
            }
        }
        
        if (array_key_exists($name, $this->subject_data)) {
            return $this->subject_data[$name];
        }
    }
    
    /**
     *  Retrieves subject(s) record from the subject table, qualified by the
     *  $selection and $where options.
     *
     * @param array $select
     * @param mixed $where array or string
     * @param boolean $return_type
     */
    public function get_subjects(Select $select){
        return $this->CI->Subject_model->get($select);
    }

    /**
     * Insert a subject record with Insertion data.
     * @param Insert $insert
     * @return integer
     */
    public function add_subject(Insert $insert){
        return $this->CI->Subject_model->add($insert);
    }

    /**
     * Update a subject record with Insertion data.
     * @param Insert $insert
     * @return <type>
     */
    public function update_subject(Insert $insert){
        $result = $this->CI->Subject_model->update($insert);

        $this->subject_data = $this->get_state_info();
        
        return $result;
    }

    public function set_current_round_index($round_reference = 0){
        if(empty($round_reference)){
            return false;
        }

        $this->current_round_index = $round_reference;
        return true;
    }
    

    /**
     * Sets the subjects round order for a given
     * stage.
     *
     * Note: The rounds param must be a comma
     * delimited string of sequential integers.
     * @param string $rounds
     * @return boolean
     */
    public function set_round_order($rounds = ''){
        if(empty($rounds)){
            return false;
        }

       $insert = new Insert();
       $insert->set_where(array('id'=>$this->id));
       $insert->set_row_data(array('first_stage_order'=>$rounds));

       return $this->update_subject($insert);
    }

    public function set_after_two_rounds_order($rounds = ''){
        if(empty($rounds)){
            return false;
        }

       $insert = new Insert();
       $insert->set_where(array('id'=>$this->id));
       $insert->set_row_data(array('second_stage_order'=>$rounds));

       return $this->update_subject($insert);
    }

    public function set_second_stage_last_round($round_str = ''){
        $rounds = explode(',', $round_str);
        $last_round_index = count($rounds)-1;
        $last_round = $rounds[$last_round_index];

        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('second_stage_last_round'=>$last_round));

        return $this->update_subject($insert);
    }

    public function set_last_round($round_str = ''){
        $rounds = explode(',', $round_str);
        $last_round_index = count($rounds)-1;
        $last_round = $rounds[$last_round_index];

        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('first_stage_last_round'=>$last_round));

        return $this->update_subject($insert);
    }

    public function set_payoff($payoff = 0){
        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('payoff'=>$payoff));

        return $this->update_subject($insert);
    }

    public function set_round_counter($round = 0){
        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('round_counter'=>$round));

        return $this->update_subject($insert);
    }



    public function increment_round_counter(){
        $next_round = $this->round_counter + 1;

        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('round_counter'=>$next_round));

        return $this->update_subject($insert);
    }

    public function set_current_round($round_id = ''){
        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('current_round'=>$round_id));

        return $this->update_subject($insert);
    }

    public function set_current_phase($phase = ''){
        if(empty($phase)){
            return false;
        }

        $insert = new Insert();
        $insert->set_where(array('id'=>$this->id));
        $insert->set_row_data(array('current_phase'=>$phase));

        return $this->update_subject($insert);
    }

    public function get_current_round_index(){
        return $this->current_round_index;
    }

    /**
     * Updates the subject state info
     * @return boolean
     */
    public function get_state_info(){
        // get subject data
        $select = new Select();
        $select->set_where(array('id'=>$this->id));
        $subject_data = $this->get_subjects($select);

        if(empty($subject_data)){
            return false;
        }

        return $subject_data[0];
    }

    /**
     * Returns the subjects current phase.
     * @return string numerical string
     */
    public function get_current_phase(){
        return $this->subject_data[0]['current_phase'];
    }


    /**
     * Authenticates the subject given the initialized properties.
     * @return boolean.
     */
    public function authenticate(){
        if(empty($this->id) || empty($this->login) || empty($this->auth) || empty($this->experiment_id)){
            return false;
        }

        if($this->auth !== 'subject'){
            return false;
        }
        
        $select = new Select();
        $select->set_select(array('current_phase'));
        $select->set_where(array('id'=>$this->id, 'login'=>$this->login));
        $subject = $this->get_subjects($select);

        if(empty($subject) || count($subject) != 1){
            return false;
        }

        $subject = $subject[0];
        if($subject['current_phase'] === 'completed'){
            return false;
        }

        return true;
    }

    /**
     * Returns the subject ID
     * @return integer
     */
    public function get_id(){
        return $this->id;
    }

    /**
     * Returns the subject login
     * @return string
     */
    public function get_login(){
        return $this->login;
    }

    public function get_experiment_id(){
        return $this->experiment_id;
    }    
}
