﻿using System;
using System.Dynamic;
using System.Reflection;

namespace tabakon.launcher
{

    // A small wrapper around COM interop to make it more easy to use.
    public class COMObject : DynamicObject
    {
        private readonly object instance;

        public static COMObject CreateObject(string progID)
        {
            return new COMObject(Activator.CreateInstance(Type.GetTypeFromProgID(progID, true)));
        }

        public COMObject(object instance)
        {
            this.instance = instance;
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            result = instance.GetType().InvokeMember(
                binder.Name,
                BindingFlags.GetProperty,
                Type.DefaultBinder,
                instance,
                new object[] { }
            );
            return true;
        }

        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            instance.GetType().InvokeMember(
                binder.Name,
                BindingFlags.SetProperty,
                Type.DefaultBinder,
                instance,
                new object[] { value }
            );
            return true;
        }

        public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
        {
            result = instance.GetType().InvokeMember(
                binder.Name,
                BindingFlags.InvokeMethod,
                Type.DefaultBinder,
                instance,
                args
            );
            return true;
        }
    }
}