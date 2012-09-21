<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Experiment Added</title>
	<link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.all.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.autocomplete.css'?>" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
	<script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
</head>

<body>
<div class="management_navigation">
    <ul>
         <li><a href="<?=base_url()?>experimenter/home">Home</a></li>
         <li><a href="<?=base_url()?>experimenter/add_experiment">Add Experiment</a></li>
         <li><a href="<?=base_url()?>experimenter/manage_experiments">Manage Experiments</a></li>
     </ul>
</div>
   
        <div id="management_border">
            <h2>EXPERIMENT ADDED</h2>

            <p>Subjects Added:<?=$num_subjects_added?><br />
               Experiment ID: <?=$experiment_id?></p>

        </div> <!-- content div -->
</body>
</html>
