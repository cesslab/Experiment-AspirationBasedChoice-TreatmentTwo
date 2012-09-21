<?php
class After_one_conditional_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'after_one_conditional';
        $this->table_fields = array('id', 'subject_id', 'round_id', 'bundle_id');
    }


}