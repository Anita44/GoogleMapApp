/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.trialperiod.googlemapapp.logic;

import java.util.List;

/**
 *
 * @author Luis Fernández <@lfernandez93>
 */
public interface DAO<T> {

    public boolean insert(T object);

    public T get(T object);

    public List<T> getAll();

    public boolean delete(T object);

    public boolean update(T object);

}
