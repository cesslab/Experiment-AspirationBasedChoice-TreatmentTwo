<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Experiment Instructions</title>
	<link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
	<script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
</head>

<body>
    <div id="content">
        <div id="login_border">
        <label class="field_label">Please select the continue button when notified to do so by the experimenter.</label>
        <?=form_open(base_url().'subject/intro_phase_one')?>
        <?=form_submit(array('name'=>'submit', 'value'=>'Continue', 'id'=>'button'))?>
        <?=form_close()?>
        
        </div> <!-- wrapper div -->
    </div>
</body>
</html>
