<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>ADD Experiment</title>
        <link href="<?=base_url().'assets/css/ui.selectmenu.css'?>" rel="stylesheet" type="text/css" />
	<link href="<?= base_url().'assets/css/add_experiment.css'?>" rel="stylesheet" type="text/css" />
        <link type="text/css" href="<?=base_url().'assets/css/eggplant/jquery-ui-1.8.4.custom.css'?>" rel="stylesheet" />
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
        <script type="text/javascript" src="<?=base_url().'assets/js/ui.selectmenu.js'?>"></script>
        <link href="<?=base_url().'assets/css/ui.selectmenu.css'?>" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
           $(function(){
                $('select#treatment_dropdown').selectmenu();
            });
            </script>
</head>

<body>
    
            <div id="management_navigation">
             <ul>
                 <li><a href="<?=base_url()?>experimenter/home">Home</a></li>
                 <li><a href="<?=base_url()?>experimenter/manage_experiments">Manage Experiments</a></li>
             </ul>
            </div>
   
    
        <div id="management_border">
            <h2>Add Experiment</h2>
             <?=form_open(base_url().'experimenter/add_experiment')?>
                <table>
                    <tr>
                        <td class="input_label">
                        <label class="field_label">Number Of Subjects</label>
                        </td>
                        <td>
                        <?=form_input(array('class'=>'text_field', 'name'=>'num_subjects', 'value'=>set_value('num_subjects'), 'id'=>'text-field'))?>
                        </td>
                    </tr>
                    <tr>
                        <td class="field_error">
                            <?=form_error('num_subjects')?>
                        </td>
                    </tr>
                    <tr>
                        <td  class="input_label">
                        <label class="field_label">Show-up-fee</label>
                        </td>
                        <td>
                        <?=form_input(array('class'=>'text_field', 'name'=>'showupfee', 'value'=>set_value('showupfee'), 'id'=>'text-field'))?>
                        </td>
                    </tr>
                    <tr>
                        <td class="field_error">
                            <?=form_error('showupfee')?>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="field_label">Treatment:</label>
                        </td>
                        <td>
                            <?= form_dropdown('treatment', $treatment, set_value('treatment'), 'id="treatment_dropdown"') ?>
                        </td>
                    </tr>
                </table>
            <?=form_submit(array('name'=>'submit', 'value'=>'Submit', 'id'=>'button'))?>
            <?=form_close()?>

        </div> <!-- content div -->
</body>
</html>
