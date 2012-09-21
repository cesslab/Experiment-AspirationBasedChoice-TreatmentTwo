<table id="hor-minimalist-b">
    <tr>
        <th>id</th><th>login</th><th>Current Round</th><th>Current Phase</th><th>First Stage Order</th>
        <th>Second Stage Order</th><th>Payoff</th>
    </tr>
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
                                title: 'First Stage Order',
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
                                        title: 'Second Stage Order',
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