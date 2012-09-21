<?php
class Displayed_round_order_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'displayed_round_order';
        $this->table_fields = array('id', 'phase', 'subject_id', 'round_id', 'displayed_round');
    }


}