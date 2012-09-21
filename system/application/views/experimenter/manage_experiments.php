<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Manage Experiments</title>
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
                 <li><a href="<?=base_url()?>experimenter/add_experiment">Add Experiment</a></li>
             </ul>
            </div>
        </div>

    
        <div id="management_border">
            <label class="field_label">Manage Experiments</label>
                
            <table id="hor-minimalist-b">
                <tr><th>id</th><th>Number of Subjects</th><th>Started Phase One</th><th>Started Phase Two</th><th>Treatment</th><th>Showup Fee</th><th>Manage</th><th>View Data</th><th>Output File</th></tr>
                <?php foreach($experiments as $experiment):?>
                <tr>
                    <?php
                        $num_columns = count($experiment);
                        $counter = 0;
                     ?>
                    <?php foreach($experiment as $column):?>
                        
                    <td><?=$column?></td>
                    <?php if($counter == ($num_columns-1)):?>
                    <td>
                        <?=form_open(base_url().'experimenter/manage_experiments')?>
                        <?=form_hidden('id', $experiment['id']);?>
                        <?=form_submit(array('name'=>'submit', 'value'=>'Manage', 'id'=>'table-button'))?>
                        <?=form_close()?>
                    </td>
                    <td>
                    <?=form_open(base_url().'experimenter/view_data')?>
                    <?=form_hidden('experiment_id', $experiment['id']);?>
                    <?=form_submit(array('name'=>'submit', 'value'=>'View Data', 'id'=>'table-button'))?>
                    <?=form_close()?>
                    </td>
                    
                    <td>
                    <?=form_open(base_url().'experimenter/experiment_output')?>
                    <?=form_hidden('experiment_id', $experiment['id']);?>
                    <?=form_submit(array('name'=>'submit', 'value'=>'Output File', 'id'=>'table-button'))?>
                    <?=form_close()?>
                    </td>
                    <?php endif;?>
                    <?php ++$counter ?>
                    <?php endforeach;?>
                </tr>
                <?php endforeach;?>
            </table>
        </div> <!-- content div -->
    
</body>
</html>
