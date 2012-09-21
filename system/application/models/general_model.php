<?php
class General_model extends Model{

    function  __construct() {
        parent::__construct();
    }
    
    public function query($query){
    	$query = $this->db->query($query);
    	
    	$result = array();
    	foreach($query->result_array() as $row){
    		$result[] = $row;
    	}
    	
    	return $result;
    }


}