<?php
class MY_Model extends Model{

    protected $table_name = '';
    protected $table_fields = '';

    function  __construct() {
        parent::Model();
    }

    function start_transaction(){
        $this->db->trans_begin();
    }

    function rollback_transaction(){
        $this->db->trans_rollback();
    }

    function commit_transaction(){
        $this->db->trans_commit();
    }

    function lock_tables($table_mode_values = array()){
        $query = 'lock tables ';

        $counter = 0;
        foreach($table_mode_values as $table=>$mode){
            $query = ($counter++ > 0)?$query.", ":$query;
            $query = $query . $table." ".$mode;
        }

        $this->db->query($query);
    }

    function unlock_tables(){
        $this->db->query('unlock tables');
    }

    /**
     * Checks that all of the $required_keys are in the $values
     * array.
     * @param array $required_keys keys that are required to be
     * found in the values array.
     * @param array $values values submitted.
     */
    function _validate_insert_keys($required_keys = array(), $values = array())
    {
        foreach($required_keys as $required_key)
                if(!isset($values[$required_key])){
                    return false;
                }

        return true;
    }

    /**
     * Returns true if all the keys in the requested_where_options array
     * are in the allowed_where_options array.
     *
     * @param array $requested_where_options
     * @param array $allowed_where_options
     * @return boolean
     */
    function _check_where_options($requested_where_options = array(), $allowed_where_options = array())
    {

        if(!is_array($requested_where_options)){
            return true;
        }

        foreach($requested_where_options as $where_key=>$where_value)
        {
            if(!in_array($where_key, $allowed_where_options)) return false;
        }
        return true;
    }

    /**
     * Returns true if all the values in the select_options array
     * are found in the allowed_select_options array, if $select_options
     * is empty, or is a string. Otherwise false is returned.
     *
     * @param array $select_options
     * @param array $allowed_select_options
     * @return boolean
     */
    function _check_select_options($select_options = array(), $allowed_select_options = array())
    {
        if(!is_array($select_options)){
            return false;
        }
        
        foreach($select_options as $select_key=>$select_value)
        {
            if(!in_array($select_key, $allowed_select_options)){
                return false;
            }
        }
        return true;
    }
    
    /**
     * Returns true if all the values in the insert_values array
     * is found in the valid_insert_keys array.
     *
     * @param array $insert_values
     * @param array $valid_insert_keys
     * @return boolean
     */
    function _check_valid_insert_keys($insert_values = array(), $valid_insert_keys = array())
    {
        foreach($insert_values as $key=>$value)
        {
            if(!in_array($key, $valid_insert_keys)) return false;
        }
        return true;
    }



    /**
     * Returns only the key,value pair specified in the valid_keys
     * array
     *
     * @param array $valid_keys
     * @param array $values
     *
     * @return array valid values specified by the $valid_keys array
     */
    function _get_valid_values($valid_keys = array(), $values = array()){
        $new_values = array();
        foreach($valid_keys as $valid_key){
            if(isset($values[$valid_key]))
                $new_values[$valid_key] = $values[$valid_key];
        }
        return $new_values;
    }

    /**
     * Returns true if at least one element in the primary_keys array
     * has a corresponding key,value pair in the values array.
     *
     * @param array $primary_keys
     * @param array $values
     *
     * @return boolean
     */
     function _primary_key_found($primary_keys = array(), $values = array())
    {
        foreach($primary_keys as $primary_key){
             if(isset($values[$primary_key]))
                 return true;
        }
        return false;
     }

    /**
     * Returns an array containing all of the elements in the
     * $values array that have not been selected for removal, specified
     * in the $invalid_keys array.
     *
     * @param array $invalid_keys
     * @param array $values
     * @return array  elements not found in elements_to_remove
     */
    function _remove_invalid_values($invalid_keys = array(), $values = array()){
        $new_values = array();
        foreach($values as $key=>$value){
            if(!in_array($key, $invalid_keys))
                $new_values[$key] = $value;
        }
        return $new_values;
    }

    public function add(Insert $insert){
        $insert->set_table_name($this->table_name);
        $insert->set_table_fields($this->table_fields);

        return $this->_add_record($insert);
    }

    public function get(Select $select) {
        $select->set_table_name($this->table_name);
        $select->set_table_fields($this->table_fields);

        return $this->_get_records($select);
    }

    public function update(Insert $insert){
        $insert->set_table_name($this->table_name);
        $insert->set_table_fields($this->table_fields);

        return $this->_update_record($insert);
    }

    /**
     * Adds a record to a table, the name of which
     * is stored in the insert object.
     *
     * Requirement: the insert objects row_data, table_fields,
     * and table name must be set.
     *
     * @param Insert $insert
     * @return mixed boolean or integer
     */
    private function _add_record(Insert $insert){
        $row_data = $insert->get_row_data();
        $table_fields = $insert->get_table_fields();
        $table_name = $insert->get_table_name();

        /* Validate values required for table insertion */

        if(!is_string($table_name) ||  empty($table_name)){
            return false;
        }

        if(empty($row_data)){
            return false;
        }

        if(!is_array($row_data) && !is_string($row_data)){
            return false;
        }

        if(!$this->_check_valid_insert_keys($row_data, $table_fields)){
            return false;
        }

        $this->db->insert($table_name, $row_data);

        return $this->db->insert_id();
    }

    private function _update_record(Insert $insert){
        $row_data = $insert->get_row_data();
        $table_fields = $insert->get_table_fields();
        $table_name = $insert->get_table_name();
        $where = $insert->get_where();
        
        if(!is_string($table_name) ||  empty($table_name)){
            return false;
        }

        if(empty($row_data)){
            return false;
        }

        if(!is_array($row_data) && !is_string($row_data)){
            return false;
        }

        if(!$this->_check_valid_insert_keys($row_data, $table_fields)){
            return false;
        }

        return $this->db->update($table_name, $row_data, $where);
    }

    /**
    *
    * Retrieve records form the specified by table, and qualified
    * by the query objects attributes.
    *
    * @param mixed $select selection object
    *
    * @return mixed array or false
    */
    private function _get_records(Select $select){
        $this->db->select($select->get_validated_select());        

        /*
       *  WHERE:    The $where_options array is used if it is properly set,
       *            or if it is a non empty string.
       */
        $where = $select->get_where();
        if(!empty($where))
        {
            if(is_array($where))
            {
                $this->db->where($where);
            }
            elseif(is_string($where))
            {
                $this->db->where($where, NULL, FALSE);
            }else{
                return FALSE;
            }
        }

        /*
       * LIKE:      The $limit array is used if it is properly set, otherwise it is ignored.
       */
        $like = $select->get_like();
        if(!empty($like)){
            $this->db->like($like);
        }

        /*
       * LIMIT:     The $limit_options array is applied if it is set and valid,
       *            otherwise it is ignored.
       */
        $limit = $select->get_limit_options();
        if(!empty($limit)) {
            $allowed_selection_options = array('limit', 'offset', 'sort_by', 'sort_direction');
            if(!$this->_check_where_options($limit, $allowed_selection_options)) return false;

            if(isset($limit['limit']) && isset($limit['offset']))
                    $this->db->limit($limit['limit'], $limit['offset']);

            if(isset($limit['sort_by']) && isset($limit['sort_direction']))
                    $this->db->order_by($limit['sort_by'], $limit['sort_direction']);
        }

        /*
       * QUERY:     Selects the qualified records from the subjects table.
       */
        $query = $this->db->get($select->get_table_name());

        /* RETURN TYPE:  The $return_type string is used to determine what the return type
       *               should be. Either a query object, object_array, or an array (default).
       */
        $return_type = $select->get_return_type();
        if($return_type === 'query')
            return $query;
        if($return_type === 'object_array')
            return $query->result();
        else
            return $query->result_array();
    }
   
}