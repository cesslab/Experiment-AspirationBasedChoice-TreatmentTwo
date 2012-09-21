<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Experimenter Login</title>
	<link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.all.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.autocomplete.css'?>" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
	<script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
</head>

<body>
     <div id="navigation">
            <div class="management_navigation">
             <ul>
                 <li><a href="<?=base_url()?>experimenter/add_experiment">Add Experiment</a></li>
                 <li><a href="<?=base_url()?>experimenter/manage_experiments">Manage Experiments</a></li>
             </ul>
            </div>
        </div>
    
        <div id="management_border">
            <h2>Experiment Management</h2>
            <p>The "Add Experiment" screen you can create an experiment (i.e. specify treatment type, and
            the number of subjects). Note: The login and passwords are automatically generated when an
            experiment is added (or created). Subject passwords are simply their generated login with "0011"
            appended. For example, a subject with the generated login of "foobar" would have the password
            "foobar0011".</p>
            <p>The "Manage Experiments" screen provides a view of all created experiments. From this screen you
            can choose to manage a particular experiment by selecting the Manage Button. When managing a specific
            experiment you can view all subjects (refreshing the page is necessary to view the subjects state change)
            and initialize the first and second phase.</p>
        </div> <!-- content div -->
    
</body>
</html>
