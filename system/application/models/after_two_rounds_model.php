<?php
class After_two_rounds_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'after_two_rounds';
        $this->table_fields = array('id', 'round_id');
    }


}
