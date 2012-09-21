<?php
class Minimum_compensation_model extends MY_Model{
     function  __construct() {
        parent::__construct();

        $this->table_name = 'minimum_compensation';
        $this->table_fields = array('id', 'subject_id', 'round_id', 'bundle_id', 'amount');
     }
     
     
}