<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Phase One</title>
    <link href="<?= base_url().'assets/css/style.css'?>" rel="stylesheet" type="text/css" />
    <link type="text/css" href="<?=base_url().'assets/css/eggplant/jquery-ui-1.8.4.custom.css'?>" rel="stylesheet" />
    <script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
    <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.5.custom.min.js'?>"></script>
    <script type="text/javascript">
	$(document).ready(function(){
		$("#radio").buttonset();
                <?php
                $i = 0;
                foreach($bundle_descriptions as $bundle_description): ?>
                $("#radio<?=$i?>").button({disabled:false});
                $("#radio<?=$i?>").attr('checked', false);
                $("#radio<?=$i?>").button('refresh');
                    <?php if(!$bundles[$i]['availability']): ?>                 	
                        $("#radio<?=$i?>").button({disabled:true});
                    <?php endif;?>
                <?php ++$i?>
                <?php endforeach;?>

                $("#button").hide();

            	$("#radio :radio").click(function(){
                    if($(this).val()){
                        $("#button").show();
                 	}  		   
  				});

            	$("#button").click(function(){
                        $("#button").attr('disabled','disabled');
                        $('#login_border').fadeOut();		   
  				});
	});
	</script>
	<script type="text/javascript">

	</script>
</head>

<body>
    <div id="content">
        <div id="login_border">

            <div id="question"><?=$question?></div>
     <?=form_open(base_url().'subject/phase_one')?>

            <div id="radio">
                <table>
                	<tr><td class="bundle_error">
                        <?=form_error('bundle_id')?>
                    </td></tr>
            <?php
                $i = 0;
                foreach($bundle_descriptions as $bundle_description): ?>
                    <tr><td id="bundles">
                            <?php if($bundles[$i]['availability']): ?>
                                <input type="radio" class ="radio<?=$i?>" id="radio<?=$i?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" /><label for="radio<?=$i?>"><?=$bundle_description?></label>
                            <?php else:?>
                                <input type="radio" class ="radio<?=$i?>" id="radio<?=$i?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" /><label for="radio<?=$i?>"><?=$bundle_description?></label> <label id="bundle_disabled">[Unavailable]</label>
                            <?php endif;?>
                    </td></tr>
                        <?php ++$i?>
            <?php endforeach;?>
                </table>
           </div>

        <?=form_submit(array('name'=>'submit', 'value'=>'Submit', 'id'=>'button'))?>
        <?=form_close()?>
        </div>
    </div>

</body>
</html>
