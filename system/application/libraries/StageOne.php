<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class StageOne {

    private $treatment;

    private $round_model;

    public function  __construct() {
        $this->CI->load->model('Stage_one_after_round_model');
        $this->stage_one_round_model =& $this->CI->Stage_one_after_round_model;
    }

    }