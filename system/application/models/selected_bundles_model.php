<?php
class Selected_bundles_model extends MY_Model{
     function  __construct() {
        parent::__construct();

        $this->table_name = 'after_selected_bundles';
        $this->table_fields = array('id', 'round_id', 'subject_id', 'bundle_id');
    }
}
?>
