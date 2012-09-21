<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Experiment {

    private $treatment;

    private $CI;

    private $experiment_id = '';
    private $experiment_data = array();

    private $stage_one_round_model;
    private $stage_two_round_model;

    private $bundle_model;
    private $item_model;
    private $question_model;

    private $outcome_model;
    
    private $selected_bundle_model;
    private $conditional_rounds_model;

    private $minimum_compensation_model;
    
    private $displayed_round_model;

    /**
     * Initializes Experiment class properties, models,
     * and CodeIgniter reference.
     * @param mixed $experiment_id integer or numeric string
     */
    function  __construct($experiment_id = '') {
        $this->CI = &get_instance();

        $this->experiment_id = (is_numeric($experiment_id))?$experiment_id:'';

        $this->CI->load->model('Experiment_model');

        // select the this experiments treatment
        $select = new Select();
        $select->set_select(array('treatment'));
        $treatment = $this->CI->Experiment_model->get($select);

        //load the appropriate round model for the specified treatment
        if($treatment[0]['treatment'] === "After"){
            $this->CI->load->model('Stage_one_after_round_model');
            $this->stage_one_round_model =& $this->CI->Stage_one_after_round_model;

            $this->CI->load->model('Treatment_after_question_model');
            $this->question_model =& $this->CI->Treatment_after_question_model;

            $this->CI->load->model('Treatment_after_bundle_model');
            $this->bundle_model =& $this->CI->Treatment_after_bundle_model;

            $this->CI->load->model('Treatment_after_item_model');
            $this->item_model =& $this->CI->Treatment_after_item_model;

            $this->CI->load->model('Selected_bundles_model');
            $this->selected_bundle_model =& $this->CI->Selected_bundles_model;

            $this->CI->load->model('After_one_conditional_model');
            $this->conditional_rounds_model =& $this->CI->After_one_conditional_model;

            $this->CI->load->model('After_two_rounds_model');
            $this->stage_two_round_model =& $this->CI->After_two_rounds_model;

            $this->CI->load->model('Minimum_compensation_model');
            $this->minimum_compensation_model =& $this->CI->Minimum_compensation_model;

            $this->CI->load->model('Outcome_model');
            $this->outcome_model =& $this->CI->Outcome_model;
            
            $this->CI->load->model('Displayed_round_order_model');
            $this->displayed_round_model =& $this->CI->Displayed_round_order_model;
        }else{
            $this->CI->load->model('Stage_one_before_round_model');
            $this->stage_one_round_model =& $this->CI->Stage_one_before_round_model;
        }
        if(!empty($experiment_id)){
            $this->experiment_data = $this->get_state_info();
        }

    }

    public function __get($name) {
        if (array_key_exists($name, $this->experiment_data)) {
            return $this->experiment_data[$name];
        }
    }

    private function get_outcome(Select $select){
        return $this->outcome_model->get($select);
    }

    private function get_phase_one_rounds(Select $select){
        return $this->stage_one_round_model->get($select);
    }

    private function get_phase_two_rounds(Select $select){
        return $this->CI->After_two_rounds_model->get($select);
    }

    private function get_questions(Select $select){
        return $this->question_model->get($select);
    }

    private function get_phase_one_bundles(Select $select){
        return $this->bundle_model->get($select);
    }

    private function get_phase_one_items(Select $select){
        return $this->item_model->get($select);
    }

    private function get_experiments(Select $select){
        return $this->CI->Experiment_model->get($select);
    }

    private function get_phase_one_selected_bundles(Select $select){
        return $this->selected_bundle_model->get($select);
    }

    private function get_phase_one_conditional_rounds(Select $select){
        return $this->conditional_rounds_model->get($select);
    }

    private function get_minimum_compensation(Select $select){
        return $this->minimum_compensation_model->get($select);
    }
    
	private function get_displayed_round(Select $select){
    	return $this->displayed_round_model->get($select);
    }

    private function add_phase_one_selected_bundles(Insert $insert){
        $result = $this->selected_bundle_model->add($insert);
        return $result;
    }

    private function add_outcome(Insert $insert){
        $result = $this->outcome_model->add($insert);

        return $result;
    }

    private function add_phase_one_conditional_rounds(Insert $insert){
        $result = $this->conditional_rounds_model->add($insert);
    }

    private function add_minimum_compensation_model(Insert $insert){
        $result = $this->minimum_compensation_model->add($insert);
    }
    
    private function add_displayed_round(Insert $insert){
    	$result = $this->displayed_round_model->add($insert);
    }


    public function get_min_comp($bundle_id, $subject_id){
        if(empty($bundle_id)){
            return false;
        }

        $select = new Select();
        $select->set_where(array('subject_id'=>$subject_id, 'bundle_id'=>$bundle_id));

        $result = $this->get_minimum_compensation($select);
        if(empty($result)){
            return false;
        }

        if(count($result) == 1){
            return $result[0];
        }

        return $result;
    }

    public function get_question_id($round_id){

        if(empty($round_id)){
            return false;
        }

        $select = new Select();
        $select->set_select(array('question_id'));
        $select->set_where(array('id'=>$round_id));

        $question_id = $this->get_phase_one_rounds($select);

        if(empty($question_id)){
            return false;
        }

        return $question_id[0]['question_id'];
    }

    public function get_question_str($question_id){
        if(empty($question_id)){
            return false;
        }

        $select = new Select();
        $select->set_select(array('question'));
        $select->set_where(array('id'=>$question_id));

        $question = $this->get_questions($select);

        if(empty($question)){
            return false;
        }

        return $question[0]['question'];
    }

    public function get_phase_one_round_bundles($round_id = 0){
        if(empty($round_id)){
            return false;
        }

        $select = new Select();
        $select->set_select(array('id', 'availability'));
        $select->set_where(array('round_id'=>$round_id));
        $bundles = $this->get_phase_one_bundles($select);

        if(empty($bundles)){
            return false;
        }

        return $bundles;
    }

    public function get_phase_one_bundle_items($bundle_id=0){
        if(empty($bundle_id)){
            return false;
        }

        $select = new Select();
        $select->set_select(array('id', 'item_type', 'item_number'));
        $select->set_where(array('bundle_id'=>$bundle_id));
        $items = $this->get_phase_one_items($select);

        if(empty($items)){
            return false;
        }

        return $items;
    }
    
    public function get_phase_one_selected_bundle($round_id = 0, $subject_id = 0){
       if(empty($round_id) || empty($subject_id)){
           return false;
       }

       $select = new Select();
       $select->set_where(array('round_id'=>$round_id, 'subject_id'=>$subject_id));
       $result = $this->get_phase_one_selected_bundles($select);

       if(empty($result) || count($result) != 1){
            return false;
        }

        return $result[0];

    }

    public function get_phase_one_conditional_round($subject_id, $round_id){
        if(empty($round_id) || empty($subject_id)){
           return false;
       }

       $select = new Select();
       $select->set_where(array('round_id'=>$round_id, 'subject_id'=>$subject_id));
       $result = $this->get_phase_one_conditional_rounds($select);

       if(empty($result)){
            return false;
        }
        
        if(count($result) == 1){
        	return $result[0];
        }

        return $result;
    }
    
	public function insert_displayed_round_id($displayed_round_id, $round_id, $subject_id, $phase){
    	$insert = new Insert();
       	$insert->set_row_data(array('displayed_round'=>$displayed_round_id, 'round_id'=>$round_id, 'subject_id'=>$subject_id, 'phase'=>$phase));

       return $this->add_displayed_round($insert);
    }

    public function insert_phase_two_minimum_entries(array $minimum_entries, $subject_id, $round_id){

        $total_result = true;
        foreach($minimum_entries as $bundle_id=>$minimum_entry){
            $insert = new Insert();
            $insert->set_row_data(array('amount'=>$minimum_entry, 'bundle_id'=>$bundle_id, 'subject_id'=>$subject_id, 'round_id'=>$round_id));
            $result = $this->add_minimum_compensation_model($insert);
            $result &= $total_result;
        }

        return $total_result;
    }

    public function insert_outcome(array $outcome){
        $insert = new Insert();
        $insert->set_row_data($outcome);

        $result = $this->add_outcome($insert);

        return $result;
    }


    public function insert_phase_one_conditional_round(array $rounds){
        if(empty($rounds)){
            return false;
        }

        $total_result = true;
        foreach($rounds as $round){
            $insert = new Insert();
            $insert->set_row_data($round);
            $result = $this->add_phase_one_conditional_rounds($insert);
            $total_result &= $result;
        }

        return $total_result;
    }

    public function insert_phase_one_selected_bundle($round_id, $subject_id, $bundle_id){
        if(empty($round_id) || empty($subject_id) || empty($bundle_id)){
            return false;
        }
        
        $insert = new Insert();
        $insert->set_row_data(array('round_id'=>$round_id, 'subject_id'=>$subject_id, 'bundle_id'=>$bundle_id));

        return $this->add_phase_one_selected_bundles($insert);
    }

    private function get_state_info(){
        // get subject data
        $select = new Select();
        $select->set_where(array('id'=>$this->experiment_id));
        $experiment_data = $this->get_experiments($select);

        if(empty($experiment_data)){
            return false;
        }

        return $experiment_data[0];
    }
    
    public function get_displayed_round_id($subject_id, $round_id, $phase){
    	if(empty($subject_id)){
    		return false;
    	}
    	
    	$select = new Select();
    	$select->set_where(array('subject_id'=>$subject_id, 'round_id'=>$round_id, 'phase'=>$phase));
    	$result = $this->get_displayed_round($select);
    	
    	if(empty($result) || count($result) != 1){
    		return false;
    	}
    	
    	return $result[0];
    }

    public function get_phase_one_round_by_id($round_id = 0){
        if(empty($round_id)){
            return false;
        }

        $select = new Select();
        $select->set_where(array('id'=>$round_id));
        $result = $this->get_phase_one_rounds($select);

        if(empty($result) || count($result) != 1){
            return false;
        }

        return $result[0];
    }

    public function get_phase_two_round_by_id($round_id = 0){
        if(empty($round_id)){
            return false;
        }

        $select = new Select();
        $select->set_where(array('id'=>$round_id));
        $result = $this->get_phase_two_rounds($select);

        if(empty($result) || count($result) != 1){
            return false;
        }

        return $result[0];
    }

    public function get_phase_two_permutated_rounds(){
        $select = new Select();

        $select->set_select('round_id');
        $rounds = $this->get_phase_two_rounds($select);

        $extracted_rounds = array();
        foreach($rounds as $parent_round){
            $extracted_rounds[] = $parent_round['round_id'];
        }

        shuffle(&$extracted_rounds);

        return implode(',', $extracted_rounds);
    }

    public function get_phase_one_permutated_rounds(){
        $select = new Select();

        $select->set_select(array('id'));
        $select->set_where(array('round_type'=>'parent'));
        $parent_rounds = $this->get_phase_one_rounds($select);

        $select->set_select(array('id', 'parent_id'));
        $select->set_where(array('round_type'=>'child'));
        $child_rounds = $this->get_phase_one_rounds($select);

        $select->set_select(array('id'));
        $select->set_where(array('round_type'=>'single'));
        $single_rounds = $this->get_phase_one_rounds($select);

        if(empty($parent_rounds) || empty($child_rounds) || empty($single_rounds)){
            return false;
        }

        // extract parent rounds
        $extracted_rounds = array();
        foreach($parent_rounds as $parent_round){
            $extracted_rounds[] = $parent_round['id'];
        }

        // extract child rounds
        $extracted_child_rounds = array();
        foreach($child_rounds as $child_round){
            $extracted_child_rounds[$child_round['parent_id']] = $child_round['id'];
        }

        // extract single rounds
        $extracted_single_rounds = array();
        foreach($single_rounds as $single_round){
            $extracted_single_rounds[] = $single_round['id'];
        }

        shuffle(&$extracted_rounds);

        // make sure round 49 comes before 59, 61, 62
        $special_rounds = array(
            '49'=>array_search(49,$extracted_rounds),
            '59'=>array_search(59,$extracted_rounds),
            '61'=>array_search(61,$extracted_rounds),
            '63'=>array_search(63,$extracted_rounds));

        // if 49 is to the right of 59, which is the left most round swap the two
        if($special_rounds['49'] > $special_rounds['59'] && $special_rounds['59'] < $special_rounds['61'] && $special_rounds['59'] < $special_rounds['63']){
            $temp  = $extracted_rounds[$special_rounds['49']];
            $extracted_rounds[$special_rounds['49']] = $extracted_rounds[$special_rounds['59']];
            $extracted_rounds[$special_rounds['59']] = $temp;
        }
        elseif($special_rounds['49'] > $special_rounds['61'] && $special_rounds['61'] < $special_rounds['59'] && $special_rounds['61'] < $special_rounds['63']){
            $temp  = $extracted_rounds[$special_rounds['49']];
            $extracted_rounds[$special_rounds['49']] = $extracted_rounds[$special_rounds['61']];
            $extracted_rounds[$special_rounds['61']] = $temp;
        }
        elseif($special_rounds['49'] > $special_rounds['63'] && $special_rounds['63'] < $special_rounds['59'] && $special_rounds['63'] < $special_rounds['61']){
            $temp  = $extracted_rounds[$special_rounds['49']];
            $extracted_rounds[$special_rounds['49']] = $extracted_rounds[$special_rounds['63']];
            $extracted_rounds[$special_rounds['63']] = $temp;
        }

        $rounds = array();
        foreach($extracted_rounds as $round){
            $rounds[] = $round;
            if(array_key_exists($round, $extracted_child_rounds)){
                $rounds[] = $extracted_child_rounds[$round];
            }
        }

        shuffle(&$extracted_single_rounds);

        foreach($extracted_single_rounds as $single_round){
            $rounds[] = $single_round;
        }
        
        return implode(',', $rounds);
    }
    
		/** 
         * Retruns true if the budle pram is not asssociated with a conditional round, otherwise false
         * is returned. 
         * 
         * If one of the parameters is empty null is returned.
         * 
         * @param integer $round_id
         * @param integer $subject_id
         * @param array $bundle
         * @param integer $previously_selected_bundle_id
         */
        public function is_bundle_conditionally_unavailable($round_id = 0, $subject_id = 0, $bundle = array(), $previously_selected_bundle){
        
        	if(empty($round_id) || empty($subject_id)){
        		return false;
        	}
        	
        	if(!isset($previously_selected_bundle['bundle_id']) || empty($previously_selected_bundle['bundle_id'])){
        		return false;
        	}else{
        		$previously_selected_bundle_id = $previously_selected_bundle['bundle_id'];
        	}
        	
        	
		        /*
		         * There are some parent rounds that have multiple children.
		         * If this is the one occasion in which the round is a child 
		         * and has many siblings disable the bundle selected in the parent
		         * round in addition to one of the randomly selected bundles for this round.
		         */
                if($round_id == 60 || $round_id == 62 || $round_id == 64){
                	$disable_bundles = $this->get_phase_one_conditional_round($subject_id, $round_id);
                	
                	$bundle_disabled = false;
                	foreach($disable_bundles as $disable_bundle){
                		if((int)$bundle['id'] == (int)$disable_bundle['bundle_id']){
                			$bundle_disabled = ($bundle_disabled || true);
                		}
                		
                		if($bundle_disabled){
                			return true;
                		}
                	}
                }
                
                /*
                 * Two round (22, 26) have two bundles that are conditionally avaiable 
                 * depending on which of the 4 bunles were selected in the previous rounds (21, 25).
                 */
                if($round_id == 22){
                	switch((int)$bundle['id']){
                		case 66:
                			if($previously_selected_bundle_id == 62 || $previously_selected_bundle_id == 61){
                				return true;
                			}
                			break;
                		case 68:
                			if($previously_selected_bundle_id == 63 || $previously_selected_bundle_id == 64){
                				return true;
                			}
                			break;
                	}
                }
                elseif($round_id == 26){
                	switch((int)$bundle['id']){
                		case 82:
                			if($previously_selected_bundle_id == 78 || $previously_selected_bundle_id == 77){
                				return true;
                			}
                			break;
                		case 84:
                			if($previously_selected_bundle_id == 80 || $previously_selected_bundle_id == 79){
                				return true;
                			}
                			break;
                	}
                }               
                elseif($bundle['id'] == $previously_selected_bundle_id){
                    return true;
                }              

                return false;
        }
        
	public function get_parent_round_id($round, $round_id){
        	if($round['conditional_bundles']){
                if($round_id == 60 || $round_id == 62 || $round_id == 64){   // one parent multiple children
                    $round_id = 49;
                }
                elseif(!empty($round['parent_id']) && $round_id != 26 && $round_id != 22){ // multiple conditions set on bundles
                    $round_id = (int)$round['parent_id'];
                }                                
            }
            	
            return 0;
        }
        
    public function get_bundles($round, $round_id, $subject_id){          	
            return $this->get_phase_one_round_bundles($round_id);
    }
        
    public function get_previously_selected_bundle($round, $round_id, $subject_id){
        	if($round['conditional_bundles']){
                if($round_id == 60 || $round_id == 62 || $round_id == 64){   // one parent multiple children
                    return $this->get_phase_one_selected_bundle(49, $subject_id);
                }
                elseif($round_id == 22){
                	return $this->get_phase_one_selected_bundle(21, $subject_id);
                }
                elseif($round_id == 26){
                	return $this->get_phase_one_selected_bundle(25, $subject_id);
                }
                elseif(!empty($round['parent_id']) && $round_id != 26 && $round_id != 22){ // multiple conditions set on bundles
                    return $this->get_phase_one_selected_bundle($round['parent_id'], $subject_id);
                }
            }
            
            return array();
        }
}
