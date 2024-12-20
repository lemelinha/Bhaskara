<?php
    if (EM_PERIODO_LETIVO) {
        ?>
            <h2>Em período Letivo</h2>
            <p>
                Início: <?= date('d/m/Y', strtotime(INICIO_PERIODO_LETIVO)) ?> <br>
                Início das Férias: <?= date('d/m/Y', strtotime(INICIO_FERIAS)) ?> <br>
                Fim: <?= date('d/m/Y', strtotime(FIM_PERIODO_LETIVO)) ?>
            </p>
        <?php

        if ($_SESSION['logged']['cargo'] == 5 && new DateTime(FIM_PERIODO_LETIVO) < new DateTime()) {
            ?>
                <button id="finalizar">Finalizar Ano Letivo</button>
                <script>
                    $('button#finalizar').on('click', function () {
                        $(this).prop('disabled', true)
                        $.ajax({
                            'url': '/docente/gerenciamento/periodo-letivo/finalizar',
                            'type': 'post',
                            'dataType': 'json'
                        })
                        .done(function (data) {
                            alert(data.msg + '\nAprovados: ' + data.aprovados + '\nReprovados: ' + data.reprovados)
                            window.location.reload()
                        })
                        $(this).prop('disabled', false)
                    })
                </script>
            <?php
        }

    } else {
        ?>
            <h2>Fora do ano letivo</h2>
            <?php
                if ($_SESSION['logged']['cargo'] >= 4) {
                    ?>
                    <form action="/docente/gerenciamento/periodo-letivo/iniciar" method="post">
                        <h3>Iniciar Ano Letivo</h3>
                        <input style="background-color: #cfa93f" type="date" name="inicio" id="inicio" min='<?= date('Y-m-d', time()+1296000) ?>'>
                        <p>Data Final: <span id="dia-final">Selecione uma data</span> <span id="dia-semana"></span></p>
                        <p>Inicio das Férias: <span id="ferias">Selecione uma data</span>
                        </p>
                        <input class="botoes" type="submit" value="Iniciar">
                        <p id="retorno"></p>
                    </form>
                    <script>
                        $(document).ready(function() {
                            // Captura a mudança no campo de data
                            $('input[type="date"]').on('change', function() {
                                var date = new Date($(this).val()); // Pega o valor da data
                                date.setDate(date.getDate() + 299)
                                if (date.getDay() == 0 || date.getDay() == 6) {
                                    date.setDate(date.getDate() + 2)
                                }
                                $('form p span#dia-final').html(String(date.getDate()).padStart(2, '0') + '/' + String(date.getMonth()+1).padStart(2, '0') + '/' + date.getFullYear())
                                $('form p span#dia-semana').html(['Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado'][date.getDay()])
                                
                                var dateFerias = new Date($(this).val());
                                dateFerias.setDate(dateFerias.getDate() + 149)
                                $('form p span#ferias').html(String(dateFerias.getDate()).padStart(2, '0') + '/' + String(dateFerias.getMonth()+1).padStart(2, '0') + '/' + dateFerias.getFullYear())
                            });
                        });

                        $('form').on('submit', function (e) {
                            e.preventDefault()
                            $('form input[type="submit"]').prop('disabled', true)
                            
                            $.ajax({
                                'url': '/docente/gerenciamento/periodo-letivo/iniciar',
                                'dataType': 'json',
                                'type': 'POST',
                                'data': $(this).serialize()
                            })
                            .done(data => {
                                console.log(data)
                                $('p#retorno').text(data.msg)
                                $('input[type="submit"]').prop('disabled', true)
                            })
                            .catch(function (a) {
                                console.log(a)
                                $('p#retorno').text('Algo deu errado')
                            })
                            $('form input[type="submit"]').prop('disabled', false)
                        })
                    </script>
                    <?php
                }
    }
?>
