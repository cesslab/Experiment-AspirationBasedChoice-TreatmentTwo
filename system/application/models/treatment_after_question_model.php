<?php
class Treatment_after_question_model extends MY_Model{

    function  __construct() {
        parent::__construct();

        $this->table_name = 'questions';
        $this->table_fields = array('id', 'question');
    }
}