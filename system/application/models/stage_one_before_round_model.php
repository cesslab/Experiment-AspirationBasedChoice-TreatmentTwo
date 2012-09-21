<?php
class Stage_one_before_round_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'treatment_after_phase_one_rounds';
        $this->table_fields = array('id', 'question', 'phase');
    }
}