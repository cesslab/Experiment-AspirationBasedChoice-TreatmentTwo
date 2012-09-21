<?php
class Stage_one_after_round_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'after_one_rounds';
        $this->table_fields = array('id', 'stage_number', 'round_type', 'parent_id', 'question_id', 'conditional_bundles');
    }
}