<?php
class Treatment_after_bundle_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'after_one_bundles';
        $this->table_fields = array('id', 'round_id', 'availability');
    }
}