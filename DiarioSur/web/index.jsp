<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.List"%>
<%@page import="util.Properties"%>
<%@page import="ws.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String user = request.getParameter(Properties.USER_SELECTED);
    if (user != null) {
        user = URLDecoder.decode(user, "UTF-8");
        session.setAttribute(Properties.USER_SELECTED, user);
    } else if (session.getAttribute(Properties.USER_SELECTED) == null) {
        session.setAttribute(Properties.USER_SELECTED, user = Properties.USER_GUEST);
    } else {
        user = (String) session.getAttribute(Properties.USER_SELECTED);
    }

    List<Event> events = null;
    try {
        EventWS_Service eventService = new EventWS_Service();
        EventWS eventPort = eventService.getEventWSPort();
        events = eventPort.findAllEvents();
    } catch (Exception ex) {
        System.err.println("Error getting events from service");
        ex.printStackTrace();
    }

    List<Category> categories = null;
    try {
        CategoryWS_Service categoryService = new CategoryWS_Service();
        CategoryWS categoryPort = categoryService.getCategoryWSPort();
        categories = categoryPort.findAllCategories();
    } catch (Exception ex) {
        System.err.println("Error getting categories from service");
        ex.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Agenda - Diario Sur</title>

        <link rel="icon" href="img/brand/favicon.ico"/>
        <link rel="shortcut icon" href="img/brand/favicon.ico" type="image/x-icon"/>
        <link rel="apple-touch-icon" sizes="57x57" href="img/brand/apple-touch-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="img/brand/apple-touch-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="img/brand/apple-touch-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="img/brand/apple-touch-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="img/brand/apple-touch-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="img/brand/apple-touch-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="img/brand/apple-touch-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="img/brand/apple-touch-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="img/brand/apple-touch-icon-180x180.png">
        <link rel="icon" type="image/png" href="img/brand/favicon-16x16.png" sizes="16x16">
        <link rel="icon" type="image/png" href="img/brand/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="img/brand/favicon-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="img/brand/android-chrome-192x192.png" sizes="192x192">
        <meta name="msapplication-square70x70logo" content="img/brand/smalltile.png"/>
        <meta name="msapplication-square150x150logo" content="img/brand/mediumtile.png"/>
        <meta name="msapplication-wide310x150logo" content="img/brand/widetile.png"/>
        <meta name="msapplication-square310x310logo" content="img/brand/largetile.png"/>

        <link rel="stylesheet" href="css/bootstrap-darkly.min.css">
        <link rel="stylesheet" href="css/material-icons.css">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/daterangepicker.css">
        <link rel="stylesheet" href="css/app.css">

        <script src="js/jquery-3.2.1.min.js"></script>
        <script src="js/popper.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/wow.min.js"></script>
        <script src="js/moment.js"></script>
        <script src="js/daterangepicker.js"></script>
    </head>
    <body>
        <!-------- #NAVBAR -------->
        <nav class="navbar navbar-dark bg-warning navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand" href="/DiarioSur/">
                    <img src="img/logo.png" height="30" class="d-inline-block align-top" alt="logo">
                    <span class="text-secondary" style="margin-left: 16px;">Agenda</span>
                </a>

                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Expandir navegación">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item active">
                            <!-- a class="nav-link text-secondary" href="#">Home <span class="sr-only">(current)</span></a -->
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <span class="badge badge-pill badge-secondary mt-3 mr-4">
                                <%
                                    if (user.equals(Properties.USER_GUEST)) {
                                %>
                                <%= user.substring(0, 1).toUpperCase() + user.substring(1)%>
                                <%
                                    } else {
                                %>
                                <%= user%>
                                <%
                                    }
                                %>
                            </span>
                        </li>
                        <li class="nav-item">
                            <div class="btn-group">
                                <a class="btn btn-secondary btn-lg" href="profile.jsp">Ver perfil</a>
                                <button type="button" class="btn btn-lg btn-secondary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="sr-only">Desplegar</span>
                                </button>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= Properties.USER_GUEST%>">Invitado</a>
                                    <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_USER, "UTF-8")%>">Usuario</a>
                                    <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_SUPER, "UTF-8")%>">SuperUsuario</a>
                                    <a class="dropdown-item" href="index.jsp?<%= Properties.USER_SELECTED%>=<%= URLEncoder.encode(Properties.USER_EDITOR, "UTF-8")%>">Redactor</a>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <!-------- #NAVBAREND -------->

        <div class="container mt-4">
            <!-------- #JUMBOTRON -------->
            <div class="jumbotron pt-4">
                <h1 class="display-4">¡Bienvenido!</h1>
                <p class="lead">En esta página podrás descubrir todo tipo de eventos en tu zona.</p>
                <p>Desde conciertos, eventos de gastronomía, tecnología, exposiciones, eSports, deportes, intercambio de idiomas... ¡hasta convenciones de cualquier tipo!</p>
                <hr class="my-4">
                <p>También puedes listar un evento para que aparezca junto a los demás y la gente pueda encontrarlo con facilidad.</p>
                <p class="lead float-right">
                    <a class="btn btn-warning btn-lg" href="create.jsp" role="button">Crear evento</a>
                </p>
            </div>
            <!-------- #JUMBOTRONEND -------->

            <div class="row">
                <!-------- #FILTERS -------->
                <div class="col-lg-3 mb-4">
                    <h1>Buscador</h1>
                    <form>
                        <div class="form-group">
                            <!-- label for="filterKeywords"></label -->
                            <input type="text" class="form-control" id="filterKeywords" placeholder="Buscar..." name="keywords">
                        </div>
                        <div class="form-group">
                            <label for="filterCategory">Categoría</label>
                            <select class="form-control" id="filterCategory" name="category">
                                <option value="nil" disabled selected>Categoría</option>
                                <%
                                    for (int cat = 0; categories != null && cat < categories.size(); cat++) {
                                %>
                                <option value="<%= categories.get(cat).getName()%>"><%= categories.get(cat).getName()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" name="free">
                                <span class="custom-control-indicator"></span>
                                <span class="custom-control-description">Gratuitos</span>
                            </label>
                        </div>
                        <div class="form-group">
                            <label class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" name="mine">
                                <span class="custom-control-indicator"></span>
                                <span class="custom-control-description">Mis eventos</span>
                            </label>
                        </div>
                        <button type="submit" class="btn btn-warning">Filtrar</button>
                    </form>
                </div>
                <!-------- #FILTERSEND -------->

                <!-------- #CARDS -------->
                <div class="col-lg-9">
                    <div class="card-columns">
                        <%
                            for (int i = 0; events != null && i < events.size(); i++) {
                                Event e = events.get(i);
                                if (user.equals(e.getAuthor().getEmail()) || e.getApproved() == 1 || user.equals(Properties.USER_EDITOR)) {
                        %>
                        <div class="card <% if (e.getApproved() == 0 && user.equals(Properties.USER_EDITOR)) { %>border-danger<% } else { %>border-dark<% }%> wow zoomIn" data-wow-delay="0.5s">
                            <img class="card-img-top rounded" src="<%= e.getImage()%>" alt="<%= e.getName()%>" data-toggle="modal" data-target="#eventModal<%= e.getId()%>" style="cursor: pointer;">
                            <div class="card-body">
                                <h4 class="card-title"><%= e.getName()%></h4>
                                <p class="card-text">
                                    <%
                                        if (e.getDescription().length() < 80) {
                                    %>
                                    <%= e.getDescription()%>
                                    <%
                                        } else {
                                    %>
                                    <%= e.getDescription().substring(0, 80) + "..."%>
                                    <%
                                        }
                                    %>
                                </p>
                                <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#eventModal<%= e.getId()%>">
                                    Ver evento
                                </button>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <!-------- #CARDSEND -------->
            </div>
        </div>

        <!-------- #MODALS -------->
        <%
            for (int i = 0; events != null && i < events.size(); i++) {
                Event e = events.get(i);
                if (user.equals(e.getAuthor().getEmail()) || e.getApproved() == 1 || user.equals(Properties.USER_EDITOR)) {
        %>
        <div class="modal fade" id="eventModal<%= e.getId()%>" tabindex="-1" role="dialog" aria-labelledby="eventModal<%= e.getId()%>Label" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title display-4 ml-auto" id="eventModal<%= e.getId()%>Label"><%= e.getName()%></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span class="display-4" aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <nav class="nav nav-tabs nav-fill" id="eventModalTab<%= e.getId()%>" role="tablist">
                            <a class="nav-item nav-link active" id="nav-info-tab<%= e.getId()%>" data-toggle="tab" href="#nav-info<%= e.getId()%>" role="tab" aria-controls="nav-info<%= e.getId()%>" aria-selected="true">Info</a>
                            <%
                                if (user.equals(e.getAuthor().getEmail())) {
                            %>
                            <a class="nav-item nav-link" id="nav-edit-tab<%= e.getId()%>" data-toggle="tab" href="#nav-edit<%= e.getId()%>" role="tab" aria-controls="nav-edit<%= e.getId()%>" aria-selected="false">Editar</a>
                            <%
                                }
                            %>
                        </nav>
                        <div class="tab-content mt-4" id="nav-tabContent<%= e.getId()%>">
                            <!-------- #MODALINFO -------->
                            <div class="tab-pane fade show active" id="nav-info<%= e.getId()%>" role="tabpanel" aria-labelledby="nav-info-tab<%= e.getId()%>">
                                <div class="row">
                                    <div class="col-4">
                                        <img class="img-fluid rounded" src="<%= e.getImage()%>">
                                    </div>
                                    <div class="col-8">
                                        <p><%= e.getDescription()%></p>
                                    </div>
                                </div>
                                <div class="row mt-4">
                                    <table class="table table-hover">
                                        <tbody>
                                            <tr>
                                                <th class="text-right" scope="row">Autor</th>
                                                <td><%= e.getAuthor().getEmail()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Fecha de inicio</th>
                                                <td><%= e.getStartDate()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Fecha de clausura</th>
                                                <td><%= e.getEndDate()%></td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Precio</th>
                                                <td><%= e.getPrice()%>&euro;</td>
                                            </tr>
                                            <tr>
                                                <th class="text-right" scope="row">Categoría</th>
                                                <td><%= e.getCategory().getName()%></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <%
                                            StringTokenizer st = new StringTokenizer(e.getAddress());
                                            String gmaps = "https://www.google.com/maps/embed/v1/place?key=AIzaSyBvwu9R5x0YwukwkoaynDNNKVR2z2RH6p4&q=";

                                            while (st.hasMoreTokens()) {
                                                gmaps += st.nextToken();
                                                if (st.hasMoreTokens())
                                                    gmaps += "+";
                                            }
                                        %>
                                        <iframe width="100%" height="450" frameborder="0" style="border: 0;" src="<%= gmaps%>" allowfullscreen></iframe>
                                    </div>
                                </div>
                                <hr>
                                <center>
                                    <%
                                        if (e.getApproved() == 0 && user.equals(Properties.USER_EDITOR)) {
                                    %>
                                    <span class="btn-group mr-4" role="group" aria-label="Basic example">
                                        <button class="btn btn-warning" onclick="acceptEvent(<%= e.getId()%>)">Aceptar</button>
                                        <button class="btn btn-warning" onclick="rejectEvent(<%= e.getId()%>)">Rechazar</button>
                                    </span>
                                    <%
                                        }
                                    %>
                                    <a class="btn btn-warning" href="<%= e.getShopUrl()%>" target="_blank">Comprar entradas</a>
                                </center>
                            </div>
                            <!-------- #MODALINFOEND -------->
                            <!-------- #MODALEDIT -------->
                            <%
                                if (user.equals(e.getAuthor().getEmail())) {
                            %>
                            <div class="tab-pane fade" id="nav-edit<%= e.getId()%>" role="tabpanel" aria-labelledby="nav-edit-tab<%= e.getId()%>">
                                <form action="EventCRUD">
                                    <input type="hidden" name="opcode" value="<%= Properties.OP_EDIT%>">
                                    <input type="hidden" name="id" value="<%= e.getId()%>">
                                    <div class="form-group">
                                        <label for="nameInput<%= e.getId()%>">Nombre</label>
                                        <input type="text" class="form-control" id="nameInput<%= e.getId()%>" placeholder="Nombre" value="<%= e.getName()%>" name="name">
                                    </div>
                                    <div class="form-group">
                                        <label for="imgInput<%= e.getId()%>">Imagen</label>
                                        <input type="url" class="form-control" id="imgInput<%= e.getId()%>" aria-describedby="imgHelp<%= e.getId()%>" placeholder="URL de la imagen" value="<%= e.getImage()%>" name="image">
                                        <small id="imgHelp<%= e.getId()%>" class="form-text text-muted">Ha de ser una URL a una imagen PNG o JPG. Preferiblemente de 500x500px.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="addressInput<%= e.getId()%>">Dirección</label>
                                        <input type="text" class="form-control" id="addressInput<%= e.getId()%>" aria-describedby="addressHelp<%= e.getId()%>" placeholder="Dirección" value="<%= e.getAddress()%>" name="address">
                                        <small id="addressHelp<%= e.getId()%>" class="form-text text-muted">Ej: Bulevar Louis Pasteur, Malaga, Spain.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="descInput<%= e.getId()%>">Descripción</label>
                                        <textarea type="text" class="form-control" id="descInput<%= e.getId()%>" placeholder="Descripción" maxlength="1000" name="description"><%= e.getDescription()%></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label for="shopInput<%= e.getId()%>">URL de compra</label>
                                        <input type="url" class="form-control" id="shopInput<%= e.getId()%>" aria-describedby="shopHelp<%= e.getId()%>" placeholder="URL de compra" value="<%= e.getShopUrl()%>" name="shopurl">
                                        <small id="shopHelp<%= e.getId()%>" class="form-text text-muted">URL de la página de compra de entradas al evento.</small>
                                    </div>
                                    <div class="form-group">
                                        <label for="dateInput<%= e.getId()%>">Fecha y hora</label>
                                        <div class="input-group">
                                            <%
                                                String startDate = e.getStartDate();
                                                startDate = startDate.substring(0, startDate.length() - 7);
                                                String endDate = e.getEndDate();
                                                endDate = endDate.substring(0, endDate.length() - 7);
                                                String dates = startDate + " ~ " + endDate;
                                                System.out.println(dates);
                                            %>
                                            <input type="text" class="form-control cal<%= e.getId()%>" id="dateInput<%= e.getId()%>" placeholder="Fecha y hora" value="<%= dates%>" name="date">
                                            <span class="input-group-addon" id="calendarTag<%= e.getId()%>"><i class="material-icons">date_range</i></span>
                                            <script>
                                                $('.cal<%= e.getId()%>').daterangepicker({
                                                    "timePicker": true,
                                                    "timePicker24Hour": true,
                                                    "locale": {
                                                        "format": "YYYY-MM-DD HH:mm",
                                                        "separator": " ~ ",
                                                        "applyLabel": "Aceptar",
                                                        "cancelLabel": "Cancelar",
                                                        "fromLabel": "Desde",
                                                        "toLabel": "Hasta",
                                                        "customRangeLabel": "Custom",
                                                        "weekLabel": "W",
                                                        "daysOfWeek": [
                                                            "Do",
                                                            "Lu",
                                                            "Ma",
                                                            "Mi",
                                                            "Ju",
                                                            "Vi",
                                                            "Sa"
                                                        ],
                                                        "monthNames": [
                                                            "Enero",
                                                            "Febrero",
                                                            "Marzo",
                                                            "Abril",
                                                            "Mayo",
                                                            "Junio",
                                                            "Julio",
                                                            "Agosto",
                                                            "Septiembre",
                                                            "Octubre",
                                                            "Noviembre",
                                                            "Diciembre"
                                                        ],
                                                        "firstDay": 1
                                                    },
                                                    "startDate": "<%= startDate%>",
                                                    "endDate": "<%= endDate%>",
                                                    "opens": "left",
                                                    "drops": "up",
                                                    "applyClass": "btn-warning",
                                                    "cancelClass": "btn-secondary"
                                                }, function (start, end, label) {
                                                    /* callback */
                                                });
                                            </script>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="form-group col-6">
                                            <label for="categoryInput<%= e.getId()%>">Categoría</label>
                                            <select class="form-control" id="categoryInput<%= e.getId()%>" name="category">
                                                <%
                                                    for (int cat = 0; categories != null && cat < categories.size(); cat++) {
                                                %>
                                                <option value="<%= categories.get(cat).getName()%>"
                                                        <%
                                                            if (e.getCategory().getName().equals(categories.get(cat).getName())) {
                                                        %>
                                                        selected
                                                        <%
                                                            }
                                                        %>
                                                        ><%= categories.get(cat).getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="form-group col-6">
                                            <label for="priceInput<%= e.getId()%>">Precio</label>
                                            <div class="input-group">
                                                <input type="number" step="0.05" class="form-control" id="priceInput<%= e.getId()%>" aria-describedby="euroTag<%= e.getId()%>" placeholder="Precio" value="<%= e.getPrice()%>" name="price">
                                                <span class="input-group-addon" id="euroTag<%= e.getId()%>">€</span>
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                    <center>
                                        <span>
                                            <button class="btn btn-warning" type="button" onclick="deleteEvent(<%= e.getId()%>)">Borrar evento</button>
                                            <button type="submit" class="btn btn-warning">Guardar cambios</button>
                                        </span>
                                    </center>
                                </form>
                            </div>
                            <%
                                }
                            %>
                            <!-------- #MODALEDITEND -------->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>
        <!-------- #MODALSEND -------->

        <script>new WOW().init();</script>
        <script type="text/javascript">
            <%
                if (user.equals(Properties.USER_EDITOR)) {
            %>
            function acceptEvent(id) {
                if (confirm("¿Desea listar este evento en la agenda?")) {
                    window.location.replace("EventCRUD?opcode=<%= Properties.OP_APPROVE%>&id=" + id);
                }
            }

            function rejectEvent(id) {
                if (confirm("¿Desea rechazar este evento definitivamente?")) {
                    window.location.replace("EventCRUD?opcode=<%= Properties.OP_DELETE%>&id=" + id);
                }
            }
            <%
                }
            %>

            function deleteEvent(id, email) {
                if (confirm("¿Desea eliminar este evento de la agenda definitivamente?")) {
                    window.location.replace("EventCRUD?opcode=<%= Properties.OP_DELETE%>&id=" + id);
                }
            }

            /*
             function filterEvents() {
             $.ajax({
             type: "post",
             url: "testme",
             data: "input=" + $('#ip').val() + "&output=" + $('#op').val(),
             success: function(msg) {
             $('#output').append(msg);
             }
             });
             }
             */

            $(document).ready(function () {
                window.history.pushState({
                    location: "index"
                }, "", "index.jsp");
            });
        </script>
    </body>
</html>
