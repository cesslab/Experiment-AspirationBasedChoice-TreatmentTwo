<?php 
class Subject_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'subjects';
        $this->table_fields = array('id', 'login', 'password', 'experiment_id', 'current_round', 'round_counter', 'payoff',
            'current_phase', 'first_stage_order','treatment', 'first_stage_last_round', 'second_stage_order', 'second_stage_last_round');
    }

     
}