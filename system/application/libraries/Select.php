<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Select {

    private $table_name;
    private $select = array();
    private $valid_table_fields = array();
    private $where = array();
    private $like = array();
    private $return_type = '';
    private $limit_options = array();
    private $valid_limit_options = array('limit', 'offset', 'sort_by', 'sort_direction');

    /**
     * Initalizes Select properties.
     * @param array $parameters
     */
    function  __construct($parameters = array()) {
       $this->table_name = (isset($parameters['table_name']))?$parameters['table_name']:'';
       $this->select = (isset($parameters['select']) && is_array($parameters['select']))?$parameters['select']:array();
       $this->valid_table_fields = (isset($parameters['valid_table_fields']) && is_array($parameters['valid_table_fields']))?$parameters['valid_table_fields']:array();
       $this->where = (isset($parameters['where']))?$parameters['where']:array();
       $this->like = (isset($parameters['like']) && is_array($parameters['like']))?$parameters['like']:array();
       $this->return_type = (isset($parameters['return_type']) && is_string($parameters['return_type']))?$parameters['return_type']:'';
       $this->limit_options = (isset($parameters['limit_options']) && is_array($parameters['limit_options']))?$parameters['limit_options']:array();
    }

    /**
     * Returns the set table name.
     * @return string
     */
    public function get_table_name(){
        return $this->table_name;
    }

    /**
     * Returns the select array (if not empty), otherwise
     * the valid selection array is returned instead.
     * @return array
     */
    public function get_select(){
        
        // return the valid select options if select is empty (i.e. select all)
        if(empty($this->select)){
            return $this->valid_table_fields;
        }
        
        return $this->select;
    }

    /**
     * Returns the select options if they are valid, otherwise
     * all of the specified columns are returned as a select array.
     *
     * @return mixed
     */
    public function get_validated_select(){
        // return the valid select options if select is empty (i.e. select all)
        if(empty($this->select)){
            return $this->valid_table_fields;
        }

        if(is_array($this->select)){
            $validated_select = array();
            foreach($this->valid_table_fields as $valid_table_column){
                if(in_array($valid_table_column, $this->select))
                    $validated_select[$valid_table_column] = $valid_table_column;
            }
            return $validated_select;
        }

        if(is_string($this->select)){
            return $this->select;
        }

        return $this->valid_table_fields;
    }

    /**
     * Return the specified where option(s).
     * @return mixed (integer or string)
     */
    public function get_where(){
        return $this->where;
    }

    /**
     * Returns the specified like option(s).
     * @return mixed (integer or string)
     */
    public function get_like(){
        return $this->like;
    }

    /**
     * Returns the specified return type.
     * @return string
     */
    public function get_return_type(){
        return $this->return_type;
    }

    /**
     * Returns the specified limit options.
     * @return array
     */
    public function get_limit_options(){
        $validated_limit = array();

        if(!empty($this->limit_options)){
            foreach($this->valid_limit_options as $valid_key){
                if(isset($this->limit_options[$valid_key]))
                    $validated_limit[$valid_key] = $this->limit_options[$valid_key];
            }
        }
        return $validated_limit;
    }

    /**
     * Set the selection option.
     *
     * Note: Valid select options are: string, array
     * @param mixed $select (string or array)
     * @return mixed
     */
    public function set_select($select = array()){
        if(is_array($select) || is_string($select)){
            $this->select = $select;
            return true;
        }
        return false;
    }

    /**
     * Set the where option.
     *
     * Note: Valid select options are: string, array
     * @param mixed $where
     * @return <type>
     */
    public function set_where($where = array()){
        if(is_array($where) || is_string($where)){
            $this->where = $where;
            return true;
        }
        return false;
    }

    public function set_like($like = array()){
        if(is_array($like) || is_string($like)){
            $this->like = $like;
            return true;
        }

        return false;
    }

    public function set_table_name($table_name = ''){
        if(is_string($table_name)){
            $this->table_name = $table_name;
            return true;
        }
        return false;
    }

    public function set_table_fields($valid_select = array()){
        if(is_array($valid_select)){
            $this->valid_table_fields = $valid_select;
            return true;
        }
        return false;
    }

    public function set_return_type($return_type){
        if(is_string($return_type)){
            $this->return_type = $return_type;
            return true;
        }
        return false;
    }

}