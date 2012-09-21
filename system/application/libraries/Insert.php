<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Insert {

    private $table_name = '';
    private $row_data = array();
    private $table_fields = array();
    private $insertion_id = 0;
    private $where = array();

    public function  __construct() {

    }

    /**
     * Sets table
     * @param String $table_name
     * @return boolean
     */
    public function set_table_name($table_name){
        if(!is_string($table_name)){
            return false;
        }

        $this->table_name = $table_name;
        return true;
    }

    /**
     * Sets the where options used.
     *
     * NOTE: The where parameter can be either
     * an array or a query string.
     *
     * @param mixed $where
     * @return boolean
     */
    public function set_where($where = array()){
        if(is_array($where) || is_string($where)){
            $this->where = $where;
            return true;
        }
        return false;
    }

    /**
     * Set the row data used.
     *
     * NOTE: The row_data parameter can be either
     * an array or a string.
     *
     * @param mixed $row_data
     * @return boolean
     */
    public function set_row_data($row_data){
        if(!is_string($row_data) && !is_array($row_data)){
            return false;
        }

        $this->row_data = $row_data;
        return true;
    }

    /**
     * Sets the table fields (columns) used.
     * @param array $table_fields
     * @return boolean
     */
    public function set_table_fields($table_fields){
        if(!is_array($table_fields)){
            return false;
        }

        $this->table_fields = $table_fields;
        return true;
    }

    /**
     * Sets the insertion id.
     * @param integer $insertion_id
     * @return boolean
     */
    public function set_insertion_id($insertion_id){
        if(!is_bool($insertion_id) && !is_integer($insertion_id)){
            return false;
        }

        $this->insertion_id = $insertion_id;
        return true;
    }

    /**
     * Returns a where string or array
     * @return mixed
     */
    public function get_where(){
        return $this->where;
    }

    /**
     * Returns the table_name.
     * @return string
     */
    public function get_table_name(){
        return $this->table_name;
    }

    /**
     * Returns the row_data
     * @return array
     */
    public function get_row_data(){
        return $this->row_data;
    }

    /**
     * Returns the table_fields.
     * @return string
     */
    public function get_table_fields(){
        return $this->table_fields;
    }

    /**
     * Returns the insertion id
     * @return integer
     */
    public function get_insertion_id(){
        return $this->insertion_id;
    }
}