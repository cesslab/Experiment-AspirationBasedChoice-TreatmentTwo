<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class MY_Form_validation extends CI_Form_validation
{
	
	/**
	 * MY_Form_validation Constructor
	 * @param array $rules
	 */
	public function MY_Form_validation($rules = array())
	{
		parent::CI_Form_validation($rules);
	}
	
	public function compare($str, $compare_to)
	{
		return ($str === $compare_to)? TRUE : FALSE;
	}
	
	/**
	 * Determines if the str contains the specified allowed characters,
	 * found in western names.
	 * 
	 * RETURNS: true if only valid characters are found, otherwise flase. 
	 * 
	 * VALID CHARACTERS:
	 *  [a-z], [A-Z], [-`.'], and empty character [ ].
	 *  
	 * @param string $string 
	 * @return boolean 
	 */
	public function western_name($name = '')
	{
		$punctuation_found =  (preg_match('/[~!@#$%^&*,()_+={}\\\\[\]|;:"\?\/<>]/',$name) > 0)?TRUE:FALSE;
		$unicode_found = (preg_match('/[^\x00-\x80]+/', $name) > 0)?TRUE:FALSE;
		$number_found = ((preg_match('/[0-9]/',$name) > 0)?TRUE:FALSE);
		
		return ($punctuation_found || $number_found || $unicode_found)? FALSE : TRUE;
	}

        /**
         * RETURNS: True if the $name_str contains two substrings
         * delimited by an empty space(s), otherwise false is returned.
         *
         * @param String $name_str
         */
        public function first_last_name_str($name_str)
        {
           if(str_word_count($name_str) != 2)
           {
               $this->set_message('first_last_name_str', "Please enter only the first and last name.");
               return false;
           }

           return true;
        }

        /**
         * Returns true if the string does not contain unicode or the
         * invalid characters.
         *
         * INVALID CHARACTERS:
         *      '/[~!@#$%^&*,()_+={}\\\\[\]|;:"\?\/<>]/'
         * 
         * @param string $entry
         * @return boolean
         */
        public function alpha_num_lim_punct($entry = '')
        {
            log_message('debug',"\t\t**** alpha_num called ***");

           $punctuation_found =  (preg_match('/[~!@#$%^&*,()_+={}\\\\[\]|;:"\?\/<>]/',$entry) > 0)?TRUE:FALSE;
           $unicode_found = (preg_match('/[^\x00-\x80]+/', $entry) > 0)?TRUE:FALSE;

           return ($punctuation_found  || $unicode_found)?FALSE: TRUE;
        }
	
	function filter_western_name($name){
		$str =  (preg_replace('/[~!@#$%^&*,()_+={}\\\\[\]|;:"\?\/<>]/','',$name));
		$str =  (preg_replace('/[0-9]/','',$str));
		
		return filter_var($str, FILTER_SANITIZE_STRING);
	}
	
	/**
	 * 	Determines if the date string has been formated correctly.
	 * 
	 * RETURNS: true if the date string is formated as specified, otherwise false.
	 * 
	 * VALID DATE FORMATS:
	 * MM/DD/YYYY or MM-DD-YYYY
	 * 
	 * @param $date_str date string 
	 * @return  boolean
	 */
	public function date_mmddyyyy($date_str = '')
	{
		$date_format = '/^(0[1-9]|1[0-2]) *(\-|\/) *(0[1-9]|1[0-9]|2[0-9]|3[0-1]) *(\-|\/) *[1-2][0-9][0-9][0-9] */';
		return (preg_match($date_format,$date_str) > 0)?TRUE:FALSE;
	}
	
	/**
	 * 
	 * RETURNS: false if the date_str exceeds the max_date.
	 * 
	 * @param $date_str submited date string
	 * @param $max_date maximum date allowed
	 */
	public function max_date($date_str = '', $max_date = ''){
            date_default_timezone_set('America/New_York');

            if(strtotime($date_str) > strtotime($max_date))
            {
                $this->set_message('max_date',"Error: The date entered cannot exceed $max_date");
                return false;
            }

            return true;
	}

        /**
         * RETURNS: false if the date_str is set to a date
         *          before min_date
         *
         * @param $date_str submited date string
         * @param $min_date minimum date allowed
         */
        public function min_date($date_str = '', $min_date = '')
        {
            date_default_timezone_set('America/New_York');

            if(strtotime($date_str) < strtotime($min_date))
            {
                $this->set_message('min_date', "Error: The date entered cannot precede $min_date");
                return false;
            }

            return true;
        }

        /**
         * RETURNS: false if the $entered_val is not inclusively within
         * the 'MIN_INT_STR,MAX_INT_STR' range, otherwise true is returned.
         *
         * @param string entry
         * @param string range_str 'MIN_INT_STR,MAX_INT_STR'
         */
        public function int_range($entry = '', $range_str = '')
        {
            $MIN_INDEX = 0;
            $MAX_INDEX = 1;

            // If the $range_str is formatted properly test if the $entry is in range
            if(preg_match('/^[0-9]+,[0-9]+$/', $range_str))
            {
                $range = explode(',', $range_str);
                if($range[$MIN_INDEX] <= $entry && $range[$MAX_INDEX] >= $entry) return true;
            }

            $this->set_message('int_range', "Error: The value entered not within the allowed range [$range[$MIN_INDEX]-$range[$MAX_INDEX]]");
            return false;
        }

        /**
         * Return: false if $time_str is not
         * a valid format, otherwise true.
         */
        public function time_12hr($time_str)
        {
            $time_found = (preg_match('/^(0[0-9]|1[0-2]):(60|[0-5][0-9]) (am|pm|AM|PM)$/', $time_str) == 1)?TRUE:FALSE;

            if($time_found) return TRUE;

            $this->set_message('time_12hr', "Error: Invalid format entered");
            return false;
        }

         /**
     * Performs password validation with the following constraints:
     * must be between 8-254 characters long
     * must contain at least one number
     * must contain at least one punctuation mark
     * must not be the same as the login
     *
     */
    public function validate_password($password) {
        $min_len = 3;
        $max_len = 254;

        if(empty($password)){
            $this->set_message('validate_password', 'A valid password is required.');
            return false;
        }

        // does the password meet character restrictions
        if(strlen($password) <= $min_len || strlen($password) >= $max_len) {
            $this->set_message('validate_password', 'A valid password must be between 3 and 12 characters long.');
            return false;
        }

        // a string consisting of letters (lower or upper case), or number
        if(!preg_match('/^([a-z]|[A-Z]|[0-9])+$/',$password)) {
            $this->set_message('validate_password', 'A valid password may only contain letters (a-Z) and numbers [0-9].');
            return false;
        }

        // no punctuation marks
        if(preg_match('/[[:punct:]]+/',$password)) {
            $this->set_message('validate_password', 'A valid password must contain at least one punctuation mark.');
            return false;
        }

        // if we have gotten this far the password is valid
        return true;
    }

    public function validate_login($login){
        if(empty($login)){
            $this->set_message('validate_login', 'A login is required.');
            return false;
        }

        // a string consisting of letters (lower or upper case), or number
        if(!preg_match('/^([a-z]|[A-Z]|[0-9])+$/',$login)) {
            $this->set_message('validate_password', 'A valid password must contain at least one number.');
            return false;
        }

        return true;
    }

}