/*
 */
package com.yahoo.ycsb.db;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.io.*;

import com.yahoo.ycsb.ByteArrayByteIterator;
import com.yahoo.ycsb.ByteIterator;
import com.yahoo.ycsb.DB;
import com.yahoo.ycsb.DBException;

public class TraceGenClient extends DB {

    private static String tracePath;
    private static Boolean printOpCode;
    private static Map<Long, PrintWriter> traceFiles;
    private static final AtomicInteger threadCount = new AtomicInteger(0);

    @Override
    public void init() throws DBException {
        Properties props = getProperties();
        tracePath = props.getProperty("tracegen.path", "/tmp/ycsb");
        String showOpCode = props.getProperty("tracegen.opcode", "true");
        printOpCode = Boolean.valueOf(showOpCode);
        // TODO support for custom separator

        traceFiles = new ConcurrentHashMap<Long, PrintWriter>();
    }

    @Override
    public void cleanup() throws DBException {
        Iterator<Long> it = traceFiles.keySet().iterator();
        while (it.hasNext()) {
            Long key = it.next();
            traceFiles.get(key).close();
        }
    }

    private synchronized PrintWriter getPrintWriter() {
        Long threadId = Thread.currentThread().getId();
        if (!traceFiles.containsKey(threadId)) {
            int fileId = threadCount.getAndIncrement();
            String filePath = tracePath + "." + Integer.toString(fileId);
            try {
                PrintWriter p = new PrintWriter(filePath, "UTF-8");
                p.flush();
                traceFiles.put(threadId, p);
            }
            catch (Exception ex) {
                System.out.println("Unable to create trace file: " + filePath);
                System.out.println(ex.toString());
                System.exit(1);
            }
        }
        return traceFiles.get(threadId);
    }

    @Override
    public int delete(String table, String key) {
        int retVal = 0;
        PrintWriter writer = getPrintWriter();
        try {
            if (printOpCode) writer.print("delete ");
            writer.println(key);
        }
        catch (Exception ex) { retVal = 1; }
        // TODO support for <table>
        return retVal;
    }

    @Override
    public int insert(String table, String key,
            HashMap<String, ByteIterator> values) {
        int retVal = 0;
        PrintWriter writer = getPrintWriter();
        try {
            if (printOpCode) writer.print("insert ");
            writer.println(key);
        }
        catch (Exception ex) {
            System.out.println("Error!");
            retVal = 1;
        }
        // TODO support for <table> and <values>
        return retVal;
    }

    @Override
    @SuppressWarnings("unchecked")
    public int read(String table, String key, Set<String> fields,
            HashMap<String, ByteIterator> result) {
        int retVal = 0;
        PrintWriter writer = getPrintWriter();
        try {
            if (printOpCode) writer.print("read ");
            writer.println(key);
        }
        catch (Exception ex) { retVal = 1; }
        // TODO support for <table> and <fields>
        return retVal;
    }

    @Override
    public int update(String table, String key,
            HashMap<String, ByteIterator> values) {
        int retVal = 0;
        PrintWriter writer = getPrintWriter();
        try {
            if (printOpCode) writer.print("update ");
            writer.println(key);
        }
        catch (Exception ex) { retVal = 1; }
        // TODO support for <table> and <values>
        return retVal;
    }

    @Override
    public int scan(String table, String startKey, int recordCount,
            Set<String> fields, Vector<HashMap<String, ByteIterator>> result) {
        int retVal = 0;
        PrintWriter writer = getPrintWriter();
        try {
            if (printOpCode) writer.print("scan ");
            writer.println(startKey);
        }
        catch (Exception ex) { retVal = 1; }
        // TODO support for <table>, <recordCount> and <fields>
        return retVal;
    }
}
