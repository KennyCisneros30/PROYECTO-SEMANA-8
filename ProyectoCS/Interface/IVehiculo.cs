﻿using System.Data;
using System.Net;

namespace CapaDatos.Interface
{
    public class IVehiculo
    {

        private ManageSQL obj = new ManageSQL(); // Instancia de la clase ManageSQL para interactuar con la base de datos.

        // Método para insertar un vehículo en la base de datos.
        public bool InsertarVehiculo(string placa, decimal valor, int año, int cilindraje, string modelo, string color, string dni_propietario, out DataTable propietarioData)
        {
            propietarioData = VerificarDNIExistente(dni_propietario);
            if (propietarioData.Rows.Count > 0)
            {
                    var listaParametros = new List<Parametros> // Lista de parámetros necesarios para la operación.
                    {
                        // Creación de objetos Parametros con valores específicos.
                        new() { Nombre = "placa", Tipo = SqlDbType.VarChar, Valor = placa },
                        new() { Nombre = "valor", Tipo = SqlDbType.Decimal, Valor = valor },
                        new() { Nombre = "año", Tipo = SqlDbType.Int, Valor = año },
                        new() { Nombre = "cilindraje", Tipo = SqlDbType.Int, Valor = cilindraje },
                        new() { Nombre = "modelo", Tipo = SqlDbType.VarChar, Valor = modelo },
                        new() { Nombre = "color", Tipo = SqlDbType.VarChar, Valor = color },
                        new() { Nombre = "dni_Propietario", Tipo = SqlDbType.VarChar, Valor = dni_propietario }
                    };
                obj.ejecutaSP_NonQuery("InsertarVehiculo", listaParametros); // Ejecuta el procedimiento almacenado con la lista de parámetros.
                return true;
            }
            return false;
        }

        // Método para modificar un vehículo en la base de datos.
        public bool ModificarVehiculo(string placa, decimal valor, int año, int cilindraje, string modelo, string color, int idPropietario)
        {
            var listaParametros = new List<Parametros>
            {
                new() { Nombre = "placa", Tipo = SqlDbType.VarChar, Valor = placa },
                new() { Nombre = "valor", Tipo = SqlDbType.Decimal, Valor = valor },
                new() { Nombre = "año", Tipo = SqlDbType.Int, Valor = año },
                new() { Nombre = "cilindraje", Tipo = SqlDbType.Int, Valor = cilindraje },
                new() { Nombre = "modelo", Tipo = SqlDbType.VarChar, Valor = modelo },
                new() { Nombre = "color", Tipo = SqlDbType.VarChar, Valor = color },
                new() { Nombre = "ID_Propietario", Tipo = SqlDbType.Int, Valor = idPropietario }
            };
            return obj.ejecutaSP_NonQuery("ModificarVehiculo", listaParametros);
        }

        // Método para eliminar un vehículo de la base de datos.
        public bool EliminarVehiculo(string placa)
        {
            var listaParametros = new List<Parametros>
            {
                new() { Nombre = "placa", Tipo = SqlDbType.VarChar, Valor = placa }
            };

            return obj.ejecutaSP_NonQuery("EliminarVehiculo", listaParametros);
        }

        // Método para buscar un vehículo por su placa en la base de datos.
        public DataTable BuscarVehiculoPorPlaca(string placa)
        {
            var listaParametros = new List<Parametros>
            {
                new Parametros { Nombre = "@Placa", Tipo = SqlDbType.VarChar, Valor = placa }
            };

            return obj.ejecutaSP_Query("BuscarVehiculoPorPlaca", listaParametros);
        }

        // Método para verificar si existe un propietario con el DNI especificado en la base de datos.
        public DataTable VerificarDNIExistente(string dni_propietario)
        {
            var listaParametros = new List<Parametros>
            {
                new() { Nombre = "@DNI", Tipo = SqlDbType.VarChar, Valor = dni_propietario }
            };

            return obj.ejecutaSP_Query("VerificarDNI", listaParametros);

        }

        public bool CalcularDeuda(string placa)
        {
            var listaParametros = new List<Parametros>
            {
                new() { Nombre = "placa", Tipo = SqlDbType.VarChar, Valor = placa }
            };

            return obj.ejecutaSP_NonQuery("CalcularDeudaVehicular", listaParametros);
        }

    }
}
