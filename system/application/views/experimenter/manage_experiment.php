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
            <label>Subjects Table:</label>
            <div id="subjects_table">
            <table id="hor-minimalist-b">
                <tr>
                    <th>id</th><th>login</th><th>Current Round</th><th>Current Phase</th><th>First Stage Order</th>
                    <th>Second Stage Order</th><th>Payoff</th></tr>
                <?php
                        $counter = 1;
                        foreach($subjects as $subject):?>
                <tr>
                    <td><?=$subject['id']?></td>
                    <td><?=$subject['login']?></td>
                    <td><?=$subject['current_round']?></td>
                    <td><?=$subject['current_phase']?></td>
                    <?php if(strlen($subject['first_stage_order']) > 30):?>
                    <script type="text/javascript">
                                    // increase the default animation speed to exaggerate the effect
                                    $.fx.speeds._default = 1000;
                                    $(function() {
                                            $('#dialog<?=$counter?>').dialog({
                                                    autoOpen: false,
                                                    show: 'blind',
                                                    hide: 'slow',
                                                    title: 'View First Stage Order',
                                                    maxHeight:300,
                                                    width:500
                                            });

                                            $('#opener<?=$counter?>').click(function() {
                                                    $('#dialog<?=$counter?>').dialog('open');
                                                    return false;
                                            });
                                    });
                            </script>
                        <div id="dialog<?=$counter?>" title="Stage Order">
                            <p id="stage_order"><?=preg_replace('/,/', ', ', $subject['first_stage_order'])?></p>
                        </div>
                        <td><button id="opener<?=$counter?>">View First Stage Order</button></td>
                        <?php ++$counter?>
                    <?php else:?>
                        <td><?=preg_replace('/,/', ', ', $subject['first_stage_order'])?></td>
                    <?php endif;?>
                    <?php if(strlen($subject['second_stage_order']) > 30):?>
                         <script type="text/javascript">
                                    // increase the default animation speed to exaggerate the effect
                                    $.fx.speeds._default = 1000;
                                    $(function() {
                                            $('#dialog<?=$counter?>').dialog({
                                                    autoOpen: false,
                                                    show: 'blind',
                                                    hide: 'slow',
                                                    title: 'View Second Stage Order',
                                                    maxHeight:300,
                                                    width:500
                                            });

                                            $('#opener<?=$counter?>').click(function() {
                                                    $('#dialog<?=$counter?>').dialog('open');
                                                    return false;
                                            });
                                    });
                            </script>
                        <div id="dialog<?=$counter?>" title="Stage Order">
                            <p id="stage_order"><?=preg_replace('/,/', ', ', $subject['second_stage_order'])?></p>
                        </div>
                        <td><button id="opener<?=$counter?>">View Second Stage Order</button></td>
                        <?php ++$counter?>
                    <?php else:?>
                        <td><?=$subject['second_stage_order']?></td>
                    <?php endif;?>
                    <td>
                    <?php foreach($outcomes as $outcome):?>
                    <?php if($outcome['subject_id'] == $subject['id']):?>
                    	<?=$outcome['payoff']?>
                    <?php endif; ?>
                    <?php endforeach;?>
                    </td>
                </tr>
                <?php endforeach;?>
            </table>
            </div>


            <label>Experiment <?=$experiment_id?> Table:</label>
            <table id="hor-minimalist-b">
                <tr><th>id</th><th>Number of Subjects</th><th>Started Phase One</th><th>Started Phase Two</th><th>Treatment</th><th>Showup Fee</th></tr>
                <?php foreach($experiments as $experiment):?>
                <tr>
                    <?php foreach($experiment as $column):?>
                    <td>
                       <?=$column?>              
                    </td>
                    <?php endforeach;?>
                </tr>
                <?php endforeach;?>
            </table>
            <table>
                <tr>
                    <td>
                    <?=form_open(base_url().'experimenter/manage_experiment/'.$experiment_id.'/')?>
                        <?=form_hidden('phase_one_set', $phase_one_set);?>
                        <?=form_submit(array('name'=>'submit', 'value'=>$phase_one_button_str, 'id'=>'update-button-one'))?>
                        <?=form_close()?>
                    </td>                  
                    <td>
                        <?=form_open(base_url().'experimenter/manage_experiment/'.$experiment_id.'/')?>
                        <?=form_hidden('phase_two_set', $phase_two_set);?>
                        <?=form_submit(array('name'=>'submit', 'value'=>$phase_two_button_str, 'id'=>'update-button-two'))?>
                        <?=form_close()?>
                    </td>
                </tr>
            </table>
             <p>Note: Clicking on the Stage Order button reveals the randomly generated round order for that stage.</p>
             <p>Instructions:</p>
            <p>In order to start Phase One, all of the subjects must log in and go to the intro_phase_one screen. Once all subjects have reached
            the intro_phase_one screen, click on the Start Phase One Button.</p>
            <p>In order to start Phase Two, all of the subjects must complete phase_one and reach the intro_phase_two screen. Once all subjects have
            reached the intro_phase_two screen, click on the Start Phase Two Button.</p>
        </div> <!-- content div -->

</body>
</html>
