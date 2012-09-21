<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Manage Experiment</title>
	<link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
	<link href="<?= base_url().'assets/css/manage_experiment.css'?>" rel="stylesheet" type="text/css" />
        <link type="text/css" href="<?=base_url().'assets/css/eggplant/jquery-ui-1.8.4.custom.css'?>" rel="stylesheet" />
        <script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
        <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
        <script type="text/javascript">
                $(document).ready(function(){
                  setInterval(function(){
                      $('#subjects_table').fadeOut(1000).load("<?=base_url().'experimenter/manage_experiment/get_experiment_subjects_table/'.$experiment_id.'/'?>").fadeIn(1000); // Animation speed in ms meaning 2 secs.
                  } ,30000);//set interval
                });//doc.ready 
            </script>
        <script type="text/javascript">
            $(document).ready(function(){
                if(<?=$phase_one_set?>){
                    $('#update-button-one').hide();
                }

                if(<?=$phase_two_set?>){
                    $('#update-button-two').hide();
                }
            });
            </script>
        
</head>

<body>
      <div id="navigation">
            <div class="management_navigation">
             <ul>
                 <li><a href="<?=base_url()?>experimenter/home">Home</a></li>
                 <li><a href="<?=base_url()?>experimenter/add_experiment">Add Experiment</a></li>
                 <li><a href="<?=base_url()?>experimenter/manage_experiments">Manage Experiments</a></li>
             </ul>
            </div>
        </div> 
   
        <div id="management_border">
        <p>The following link show below is to a CSV file, which can be opened in Excel, Stata, and many other analitical software applications.</p>
        <p>To save this file to your computer "Right Click" on the link below and "Save as" or "Save link as", otherwise the CSV file will open in your browser.</p>
            <a href="<?=base_url().'assets/output/'.$file_name?>">Output File</a>
        </div> <!-- content div -->

</body>
</html>
