<?php
class Treatment_after_item_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'after_one_items';
        $this->table_fields = array('id', 'item_type', 'item_number', 'bundle_id');
    }
}