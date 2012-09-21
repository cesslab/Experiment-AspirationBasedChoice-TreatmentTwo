<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>View Data</title>
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
                 <li><a href="<?=base_url()?>experimenter/home">Home</a></li>
                 <li><a href="<?=base_url()?>experimenter/manage_experiments">Manage Experiments</a></li>
                 <li><a href="<?=base_url()?>experimenter/add_experiment">Add Experiment</a></li>
             </ul>
            </div>
        </div>
        <div id="management_border">
            <label class="field_label">Selected Bundles</label>
                
            <table id="hor-minimalist-b">
                <tr><th>Subject ID</th><th>Round ID</th><th>Bundle ID</th></tr>
                <?php foreach($bundles_selected as $data):?>
                <tr>
					<td><?=$data['subject_id']?></td>
					<td><?=$data['round_id']?></td>
					<td><?=$data['bundle_id']?></td>
                </tr>
                <?php endforeach;?>
            </table>
            
            <label class="field_label">Entered Minimum Compensation</label>
            <table id="hor-minimalist-b">
                <tr><th>Subject ID</th><th>Round ID</th><th>Bundle ID</th><th>Amount</th></tr>
                <?php foreach($minimum_compensation_entries as $data):?>
                <tr>
					<td><?=$data['subject_id']?></td>
					<td><?=$data['round_id']?></td>
					<td><?=$data['bundle_id']?></td>
					<td><?=$data['amount']?></td>
                </tr>
                <?php endforeach;?>
            </table>
            
            <label class="field_label">Entered Minimum Compensation</label>
            <table id="hor-minimalist-b">
                <tr><th>Subject ID</th><th>Phase Selected</th><th>Round ID</th><th>Randomly Selected Bundle ID</th><th>Random Exchange Price</th></tr>
                <?php foreach($outcome_entries as $data):?>
                <tr>
					<td><?=$data['subject_id']?></td>
					<td><?=$data['phase_selected']?></td>
					<td><?=$data['round_id']?></td>
					<td><?=$data['bundle_id']?></td>
					<td><?=$data['random_val']?></td>
                </tr>
                <?php endforeach;?>
            </table>
        </div> <!-- content div -->
    
</body>
</html>
