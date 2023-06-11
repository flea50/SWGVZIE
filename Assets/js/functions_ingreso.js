let tableIngreso;
let rowTable = "";
let divLoading = document.querySelector("#divLoading");

function openModal()
{
    rowTable = "";
    document.querySelector('#idingreso').value ="";
    document.querySelector('.modal-header').classList.replace("headerUpdate", "headerRegister");
    document.querySelector('#btnActionForm').classList.replace("btn-info", "btn-primary");
    document.querySelector('#btnText').innerHTML ="Guardar";
    document.querySelector('#titleModal').innerHTML = "Nuevo Producto";
    document.querySelector("#formIngreso").reset();
    $('#modalFormIngreso').modal('show');

}

window.addEventListener('load', function() {
    fntProductos();
}, false);

function fntProductos(){
    if(document.querySelector('#listProducto')){
        let ajaxUrl = base_url+'/Productos/getSelectProductos';
        let request = (window.XMLHttpRequest) ? 
                    new XMLHttpRequest() : 
                    new ActiveXObject('Microsoft.XMLHTTP');
        request.open("GET",ajaxUrl,true);
        request.send();
        request.onreadystatechange = function(){
            if(request.readyState == 4 && request.status == 200){
                document.querySelector('#listProducto').innerHTML = request.responseText;
                $('#listProducto').selectpicker('render');
            }
        }
    }
}