using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GradientPlaneScript : MonoBehaviour
{
    private Material _material;

    // Start is called before the first frame update
    void Start()
    {
        _material = transform.GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        var points = GameObject.FindGameObjectsWithTag("Point").Select(x => x.transform).ToList();
        var pointList = points.Select(x => x.position).Select(x => new Vector4(x.x, x.y, 0, 0)).ToList();
        _material.SetVectorArray("_Vertices", pointList);
        _material.SetFloat("_PointCount", pointList.Count);
    }
}
