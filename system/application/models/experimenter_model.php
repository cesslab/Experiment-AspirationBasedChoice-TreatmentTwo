<?php
class Experimenter_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'experimenters';
        $this->table_fields = array('id', 'login', 'password');
    }


}