<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Payoff</title>
    <link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
    <link type="text/css" href="<?=base_url().'assets/css/eggplant/jquery-ui-1.8.4.custom.css'?>" rel="stylesheet" />
    <script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
    <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
    <script type="text/javascript">
	$(function() {
		$("*[id^=radio]").buttonset();
                $("*[id^=radio]").button({disabled:true});
	});
	</script>
</head>
<?php
$i = 0;
$num_available_bundles = 0;
$num_unavailable_bundles = 0;
// count available bundles
foreach($bundle_descriptions as $bundle_description):
	if($bundles[$i]['availability'] && ((int)$bundles[$i]['id']) !== ((int)$selected_bundle_id)):
		++$num_available_bundles;
	endif;
	if(!$bundles[$i]['availability']):
		++$num_unavailable_bundles;
	endif;
	++$i;
	endforeach;
	?>
<body>
    <div id="content">
        <div id="login_border">
            <h1>Payoff Screen</h1>
            <div class="payoff">
            <div id="question">
	            <p>Round <?=$round_number?>-<?=$stage?> from phase 1 was randomly selected, where you chose 
	            bundle <input type="radio" class ="radio100" id="radio100" name="bundle_id" value="" /><label for="radio100"><?=$bundle_str?></label></p>	            
	            <p>when <?= ($num_available_bundles > 1)?"bundles":"bundle";?>
	             <?php
	                    $i = 0;
	                    foreach($bundle_descriptions as $bundle_description): ?>
	                    	<?php if($bundles[$i]['availability'] && ((int)$bundles[$i]['id']) !== ((int)$selected_bundle_id)): ?>
	                                <input type="radio" class ="radio<?=$i?>" id="radio<?=$i?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" /><label for="radio<?=$i?>"><?=$bundle_description?></label>
	                    	<?php endif;
	                    		++$i;?>
	             <?php endforeach;?>
	            <?= ($num_available_bundles > 1)?"were":"was";?> also available
	            
	            <?php 
	            if($num_unavailable_bundles != 0):
	            ?>
		            , and <?= ($num_unavailable_bundles > 1)?"bundles":"bundle";?>
		             <?php
		                    $i = 0;
		                    foreach($bundle_descriptions as $bundle_description): ?>
		                    	<?php if(!$bundles[$i]['availability']): ?>
		                                <input type="radio" class ="radio<?=$i?>" id="radio<?=$i?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" /><label for="radio<?=$i?>"><?=$bundle_description?></label>
		                    	<?php endif;
		                    	++$i;?>
		             <?php endforeach;?>
					were not.</p>
				<?php else:?>
				.</p>
				<?php endif;?>
				
	             <p>Therefore, in addition to your show-up fee of $<?=$showupfee?>, you will receive the following bundle
            	<input type="radio" class ="radio101" id="radio101" name="bundle_id" value="" /><label for="radio101"><?=$bundle_str?></label>.</p>
            	
            	</div>
            </div>
        <?=form_open(base_url().'subject/payoff')?>   
        <?=form_submit(array('name'=>'submit', 'value'=>'Submit', 'id'=>'button'))?>
        <?=form_close()?>
        </div>
    </div>
</body>
</html>
