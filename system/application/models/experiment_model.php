<?php
class Experiment_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'experiments';
        $this->table_fields = array('id', 'num_subjects', 'start_phase_one', 'start_phase_two', 'treatment', 'showupfee');
    }

    
}