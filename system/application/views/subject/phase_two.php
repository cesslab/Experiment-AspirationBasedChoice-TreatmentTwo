<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Phase Two</title>
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
                        $("#radio<?=$i?>").button({disabled:true});
                <?php ++$i?>
                <?php endforeach;?>
                $(".radio100").button({disabled:true});
	});
	</script>
</head>

<body>
    <div id="content">
        <div id="login_border">

            <div id="question"><?=$question?></div>
     <?=form_open(base_url().'subject/phase_two')?>

            <div id="radio">
                <table>
            <?php
                $i = 0;
                foreach($bundle_descriptions as $bundle_description): ?>
                <tr><td><?=form_error('minimum_compensation['.$bundles[$i]['id'].']')?></td></tr>
                <tr>
                    <td id="bundles">
                        <input type="radio" class ="radio<?=$i?>" id="radio<?=$i?>" name="bundle_id" value="<?=$bundles[$i]['id']?>" /><label for="radio<?=$i?>"><?=$bundle_description?></label>
                        <input type="text" name="minimum_compensation[<?=$bundles[$i]['id']?>]" value="<?=set_value('minimum_compensation['.$bundles[$i]['id'].']')?>" id="text-field" size="8" />
                    </td>
                </tr>
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
