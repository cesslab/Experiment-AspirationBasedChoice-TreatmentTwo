<?php
class Outcome_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'outcome';
        $this->table_fields = array('id', 'subject_id', 'experiment_id', 'phase_selected', 'round_id',  'bundle_id', 'random_val', 'min_comp', 'bundle_desc', 'payoff');
    }
}