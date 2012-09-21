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

<body>
    <div id="content">
        <div id="login_border">
            <h1>Payoff Screen</h1>
            <div class="payoff">
            <div id="question">
            <?php if(!$perfered_bundle_selected):?>
	            <p>Round <?=$round_number?> from phase 2 was randomly selected where you were provided with bundle <?=$prefered_bundle_button?>.</p>
	            <p>Of the remaining bundle(s)
	            	<?php
	            		$j = 1;
	                    $i = 0;
	                    foreach($bundle_descriptions as $bundle_description): ?>
	                    <?php if ($selected_bundle_id !== $bundles[$i]['id']):?>  	
	                    	<input type="radio" class ="radio<?=$j?>" id="radio<?=$j?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" DISABLED><label for="radio<?=$j?>"><?=$bundle_description?></label> 
	                         <?php endif;?>
	                    <?php 
	                    ++$i;
	                    ++$j;
	                    endforeach;
	                    ?>,
	            bundle <?=$selected_bundle_button?> was randomly selected as was the market price $<?=$random_compensation_amount?>.</p>
	            <p>You said that you would need to receive at least $<?=$selected_min_comp?> to switch from bundle <?=$prefered_bundle_button?> to bundle <?=$selected_bundle_button?>.</p>
	            
	            <?php if($receive_random_price):?>
				<p>Since the randomly chosen market price was greater than or equal to your stated exchange price, you will receive a show-up fee of $<?=$showupfee?>,
				bundle <?=$selected_bundle_button?>, and the randomly selected market price of $<?=$random_compensation_amount?>.</p>
				<?php else:?>
				<p>Since the randomly chosen market price was less than your stated exchange price, you will receive a show-up fee of $<?=$showupfee?>, and bundle <?=$prefered_bundle_button?>, which is 
				the bundle that you were provided with in round <?=$round_number?>.</p>
				<?php endif;?>
			<?php else:?>
			<p>Round <?=$round_number?> from phase 2 was randomly selected where you were presented with bundle <?=$prefered_bundle_button?>
			and asked to state your minimum switching prices for bundle(s)
			<?php
	            		$j = 1;
	                    $i = 0;
	                    foreach($bundle_descriptions as $bundle_description): ?>
	                    <?php if ($selected_bundle_id !== $bundles[$i]['id']):?>  	
	                    	<input type="radio" class ="radio<?=$j?>" id="radio<?=$j?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" DISABLED><label for="radio<?=$j?>"><?=$bundle_description?></label> 
	                         <?php endif;?>
	                    <?php 
	                    ++$i;
	                    ++$j;
	                    endforeach;
	                    ?>
	                    . </p><p>Previously, you had chosen bundle <?=$prefered_bundle_button?> from among these bundles.</p>
	                    <p>Among all these bundles, you preferred bundle <?=$prefered_bundle_button?> was randomly selected and therefore you will receive
	                    bundle <?=$prefered_bundle_button?> and a show-up fee of $<?=$showupfee?>.</p>	
			<?php endif;?>
            </div>
		</div>
        <?=form_open(base_url().'subject/payoff')?>
        <?=form_submit(array('name'=>'submit', 'value'=>'Submit', 'id'=>'button'))?>
        <?=form_close()?>
        </div>
    </div>
</body>
</html>
